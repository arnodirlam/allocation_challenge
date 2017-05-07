# allocation_challenge
Code challenge to determine feasible meeting room schedules

## Setup

* Install [RVM](https://rvm.io/)
  ```
  curl -sSL https://get.rvm.io | bash -s stable
  ```
* Setup project
  ```
  cd .
  gem install bundler --no-ri --no-rdoc
  bundle
  ```

## Usage

To get an example schedule, run `ruby allocate.rb`.

To run the tests: `rspec`.

## Task

You are in charge of assigning meeting rooms at your company. Especially many meetings
have been planned for next Thursday, so you decided to write a program to help you fit the
meetings within your time constraints.

- There are 2 meeting rooms
- The meetings have to be scheduled during core work hours (09:00 - 17:00)
- No meetings can be scheduled during lunchtime (12:00 - 13:00)
- Meetings at your company never overrun and can be scheduled back-to-back, with no gaps in between them
- Apart from these constraints, meetings can be placed anywhere, and the duration of gaps between them doesn't matter.

The input contains one meeting per line; the meeting title can contain any characters and is
followed by a space and the meeting duration, which is always given in minutes. Since multiple
meeting configurations are possible, the test output given here is only one of the possible
solutions, and your output doesn't have to match it as long as it meets all constraints.


### Test input

All Hands meeting 60min

Marketing presentation 30min

Product team sync 30min

Ruby vs Go presentation 45min

New app design presentation 45min

Customer support sync 30min

Front-end coding interview 60min

Skype Interview A 30min

Skype Interview B 30min

Project Bananaphone Kickoff 45min

Developer talk 60min

API Architecture planning 45min

Android app presentation 45min

Back-end coding interview A 60min

Back-end coding interview B 60min

Back-end coding interview C 60min

Sprint planning 45min

New marketing campaign presentation 30min

### Example output

#### Room 1

09:00AM All Hands meeting 60min

10:00AM API Architecture planning 45min

10:45AM Product team sync 30min

11:15AM Ruby vs Go presentation 45min

12:00PM Lunch

01:00PM Back-end coding interview A 60min

02:00PM Android app presentation 45min

02:45PM New app design presentation 45min

03:30PM New marketing campaign presentation 30min

04:00PM Customer support sync 30min

04:30PM Skype Interview A 30min

#### Room 2

09:00AM Back-end coding interview B 60min

10:00AM Front-end coding interview 60min

11:00AM Skype Interview B 30min

12:00PM Lunch

01:00PM Project Bananaphone Kickoff 45min

01:45PM Sprint planning 45min

02:30PM Marketing presentation 30min

03:00PM Developer talk 60min

04:00PM Back-end coding interview C 60min


## Approach

The problem described is a variant of the [Bin Packing Problem](https://en.wikipedia.org/wiki/Bin_packing_problem) in
that a number of items (*meetings*) need to be allocated to bins (*time frames in meeting rooms*).
Since the number of bins is given, however, optimization is not necessary; picking any feasible solution from the
solution space (all viable allocations from *meetings* to *time frames in meeting rooms*) will do.

The only relevant difference between the meetings as well as between the time slots is the duration, so the allocation problem can first be reduced to the
following:

- There are 4 *time frames in meeting rooms* of 2 different durations:
  - 2 time slots of 3 hours (both rooms, 9:00 - 12:00)
  - 2 time slots of 4 hours (both rooms, 13:00 - 17:00)
- There are 18 meetings of 3 different durations:
  - 6 meetings that take 30 min
  - 6 meetings that take 45 min
  - 6 meetings that take 60 min

To reduce computational complexity, the algorithm solves the allocation problem at this level.
To return all feasible allocations on the user's level, each allocation would need to be expanded using the permutations
of all time frames of each duration as well as all meetings of each duration.
To return just one feasible allocation on the user's level, a feasible allocation with random order of time frames per
duration as well as meetings per duration can be used.

The allocation itself could be done with a greedy algorithm that tries random allocations until one is feasible.
However, the nicer approach is a branch-and-bound over the space of potential solutions, i.e. to design an implicit tree
structure of (partial) allocations, where the root represents 0 allocated items and each additional level represents one
additional allocated item.
In order to avoid duplicates (which would pose inefficiencies), a sort order for the (partial) allocations is designed,
which serves as order to build up the tree.
Since the order is only used for generating (partial) allocations, we don't need to define the comparison operator (`<=>`).
A feasibility check for each node (or leaf) determines if the allocation is still feasible; if not, traversal does not continue there.
To get any feasible allocation, a depth-first approach is taken, so it's not necessary to generate the whole tree before
finding any viable solution; only the current path (root to current node/leaf) must be kept in memory at any given point
in time.
In Ruby, this can be done in a particularly elegant way by using lazy enumerators, so it's possible to get an arbitrary
number of solutions without unnecessary computation.

I start with setting up the project, some basic classes and specs (that should fail), then continue with the core part,
i.e. the algorithm and methods to navigate the solution space. Finally, I will create the first usage interface: the CLI.


### Architecture

- The `Allocation` class represents (partial) allocations and can check their feasibility.
- The `Scheduler` represents an allocation problem and holds its requirements. It can yield an arbitrary number
  of feasible allocations.
- `MeetingRoom`, `Meeting` and `TimeSlot` are merely for displaying final example schedules to the user.

# HEAD

* `push_bulk` now returns the job IDs for pushed jobs. (#7)
* Remove activesupport dependency (#4)

# v0.1.1

* Remove a `require` ordering dependency. (#2)

# v0.1

* Have `push_bulk` limit the size of each push, with a default of 10,000 jobs each. Add `push_bulk!` which does not limit. (#1)

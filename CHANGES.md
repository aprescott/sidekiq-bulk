# HEAD

* Remove activesupport dependency
    *Tero Tasanen*

# v0.1.1

* Remove a `require` ordering dependency. (#2)

# v0.1

* Have `push_bulk` limit the size of each push, with a default of 10,000 jobs each. Add `push_bulk!` which does not limit. (#1)

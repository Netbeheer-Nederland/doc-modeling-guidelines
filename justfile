set shell := ["bash", "-uc"]
set windows-shell := ["bash", "-uc"]

ref_name := "git rev-parse --abbrev-ref HEAD"
major_branch_name := "git rev-parse --abbrev-ref HEAD | cut -d . -f 1"


_default:
    @just --list --unsorted --justfile {{justfile()}}

# Create new draft
[group("version-control")]
create-draft name:
    @echo "Creating new draft…"
    @echo
    @echo "Creating and tracking new draft branch…"
    @echo
    git checkout -b {{shell(major_branch_name) + "." + name}}
    git commit --allow-empty -m "Start working on draft"
    git push -u origin {{shell(major_branch_name) + "." + name}}
    @echo
    @echo "Creating new draft pull request…"
    @echo
    gh pr create --base {{shell(major_branch_name)}} --draft
    @echo "… OK."
    @echo

# Finish draft
[group("version-control")]
finish-draft:
    @echo "Finishing draft…"
    @echo
    @echo "Marking draft pull request as ready for review…"
    @echo
    gh pr ready
    @echo "… OK."
    @echo

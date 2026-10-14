# navigator-uptime

External uptime check for https://navigator.dccap.org (DC CAP College Navigator).

Every 5 minutes a GitHub Actions job requests `/` and `/student/careers` and fails if either page does not answer 200 within 20 seconds (one retry after 30 seconds). A failed run emails the repo owner. Before the end of launch day (2026-10-15), 401 also counts as up, because the site is behind a password until launch.

The check sends plain requests only. It collects nothing about visitors.

Run it by hand: Actions → Navigator uptime → Run workflow, or `./check.sh` locally (uses GNU `date`).

Note: GitHub turns off scheduled workflows in a public repo after 60 days with no commits. Push a commit, or re-enable the workflow under Actions, before then.

# Notes for Claude

## Video, motion graphics and animated assets

For any video, reel, caption, motion-graphics or animated GIF work, load the `update-video-workflow` skill first and follow it. The user should not have to ask for these tools.

- The skill lives in `.claude/skills/update-video-workflow/`. Its installer is `.claude/skills/update-video-workflow/scripts/setup-video-tools.sh`.
- The whole `.claude/` folder is also published as the `update-video` plugin in `.claude-plugin/marketplace.json`, so the same skills work in other projects after `/plugin install update-video@rampstack`.

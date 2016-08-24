## Do the following before creating a merge request:

1. stop the rails server
2. rake db:drop db:create db:migrate db:seed
3. rake test

## The Seven Rules of a Great Git Commit Message
<http://chris.beams.io/posts/git-commit/>

1. Separate subject from body with a blank line
2. Limit the subject line to 50 characters
3. Capitalize the subject line
4. Do not end the subject line with a period
5. Use the imperative mood in the subject line
6. Wrap the body at 72 characters
7. Use the body to explain what and why vs. how

**A properly formed git commit subject line should always be able to complete the following sentence:**

- If applied, this commit will **[your subject line here]**
 
For example:

- If applied, this commit will **refactor subsystem X for readability**
- If applied, this commit will **update getting started documentation**
- If applied, this commit will **remove deprecated methods**
- If applied, this commit will **release version 1.0.0**
- If applied, this commit will **merge pull request #123 from user/branch**

Notice how this doesn't work for the other non-imperative forms:

- If applied, this commit will **fixed bug with Y**
- If applied, this commit will **changing behavior of X**
- If applied, this commit will **more fixes for broken stuff**
- If applied, this commit will **sweet new API methods**

*Remember: Use of the imperative is important only in the subject line. You can relax this restriction when you're writing the body.*
branches=()
prefix="refs/heads/";

# retrieve branch names
for branch in $(git for-each-ref --format='%(refname)' refs/heads/); do
  branches+=(${branch#$prefix})
done

# select branch with fzf
branch=`echo "${branches[@]}" | tr ' ' '\n' | fzf --prompt "select branch"`

# ensure a branch was chosen
[ -z "$branch" ] && echo "No branch selected." && exit

# switch to branch
git checkout $branch

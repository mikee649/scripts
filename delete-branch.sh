branches=()
prefix="refs/heads/";

# retrieve branch names
for branch in $(git for-each-ref --format='%(refname)' refs/heads/); do
  branches+=(${branch#$prefix})
done

# select branches with fzf
branches=`echo "${branches[@]}" | tr ' ' '\n' | fzf --multi --prompt "select branch(es)"`

# ensure a branch was chosen
[ -z "$branches" ] && echo "No branch selected." && exit

toDelete=(`echo $branches | tr ',' ' '`)

# display branches to delete
echo "Delete branches:"
echo
for branch in "${toDelete[@]}"
do
    echo "$branch"
done
echo

# confirm the deletion
read -p "y to delete any other key to cancel: " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
  echo
  echo "Not deleting."
  exit
fi

# delete branches
echo
for branch in "${toDelete[@]}"
do
    git branch -D $branch
done

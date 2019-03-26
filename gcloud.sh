function host_mapping {
  pushd -q $HOME/dum-e/gcp
  expr=$1
  echo "searching for $1"
  rg "$1"  --no-line-number --no-filename | awk '{print $4 " " $1}'
  popd -q
}

function nodes {
  pushd -q $HOME/dum-e/gcp
  expr=$1
  _nodes=$(rg "$1" --no-line-number --no-filename | awk '{print $1}') 
  echo $_nodes
  popd -q
}

import os

import readfq

when isMainModule:
  let args = commandLineParams()
  doAssert len(args) == 1
  var path = args[0]
  echo "List of sequence names in " & path & ":"
  for rec in readfq(path):
    echo rec.name

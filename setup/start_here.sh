############################
# My personal setup script #
############################

: '
  This is a multi-tier script that first does 
  generic environmental setup like system 
  locale and then calls out to other OS
  specific scripts (macOS and Linux) where
  commands or config may be OS specific
'

LOCALE="en_NZ.UTF-8 UTF-8"

echo "Current locale is $()"
echo $LOCALE

: '
 This is a comment
'
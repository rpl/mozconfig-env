#######################################################
## mozconfig-env/zsh is not executable!!!
## You need to source it in your current fish session:
##
## . PATH/mozconfig-env/zsh MOZCONFIG_NAME
##
#######################################################

mozconfig-init() {
  local mozconfig_dir="$1"
  local mozconfig_name="$2"
  local mozconfig_path="$mozconfig_dir/$mozconfig_name"

  ## check if mozconfig-env is already active (zsh specific version)
  type -f mozconfig-switch > /dev/null
  local mozconfig_switch_is_defined=$?

  if [[ ! -f "$mozconfig_path" ]]; then
    echo -e "ERROR the required MOZCONFIG is not found:\n\t$mozconfig_path"
    local mozconfig_available=`ls $mozconfig_dir`
    echo -e "Available MOZCONFIG profiles:"
    echo -e "$mozconfig_available"  | tr " " "\n" | sed "s/^/\t- /g"
  elif [[ $mozconfig_switch_is_defined -eq 0 ]]; then
    mozconfig-switch $mozconfig_name
  else
    echo "Installing mozconfig-env helpers..."
    export _mozconfig_dir="$mozconfig_dir"
    export _mozconfig_name="$mozconfig_name"

    ## define the mozconfig commands, print the help and
    ## switch to the requested MOZCONFIG environment
    mozconfig-help() {
      echo -e "Available mozconfig-env commands:"
      echo -e "\t- mozconfig-help        prints this help"
      echo -e "\t- mozconfig-list        prints the available mozconfig environments"
      echo -e "\t- mozconfig-switch NAME switch into the NAME mozconfig environment"
      echo -e "\t- mozconfig-deativate   deactive the mozconfig-env helpers from the session"
      echo -e "\nIf you want to exit the current MOZCONFIG:\n\t$ mozconfig-deativate"
      echo -e "\nIf you want to switch the current MOZCONFIG:\n\t$ mozconfig-switch MOZCONFIG_NEW"
      echo -e "\nIf you want to exit the shell:\n\t$ exit"
    }

    mozconfig-list() {
      local mozconfig_available=`ls $mozconfig_dir`
      echo -e "Available MOZCONFIG profiles:"
      echo -e "$mozconfig_available"  | tr " " "\n" | sed "s/^/\t- /g"
    }

    mozconfig-switch() {
      local mozconfig_name="$1"
      local mozconfig_new="$_mozconfig_dir/$mozconfig_name"

      if [[ ! -f "$mozconfig_new" ]]; then
        echo -e "ERROR the new MOZCONFIG does not exist:\n\t$mozconfig_new"
      else
        export _mozconfig_name="$mozconfig_name"
        export MOZCONFIG="$mozconfig_new"
        export PROMPT="($_mozconfig_name) $OLDPROMPT"
      fi
    }

    mozconfig-deactivate() {
      unset -f mozconfig-extended-logout
      unset -f mozconfig-switch
      unset -f mozconfig-list
      unset -f mozconfig-deactivate
      unset _mozconfig_name
      unset _mozconfig_dir
      unset MOZCONFIG
      export PROMPT="$OLDPROMPT"
      unset OLDPROMPT
      bindkey -r '^D'
      set +o ignoreeof
    }

    echo -e "Activating MOZCONFIG=$mozconfig_path"
    export OLDPROMPT="$PROMPT"

    ## print the usage instruction and init the required mozconfig environment
    mozconfig-help
    mozconfig-switch $mozconfig_name

    ## prevent exit of Ctrl-D and print help
    set -o ignoreeof

    ## zsh specific extended logout
    mozconfig-extended-logout() {
      echo "\nCtrl-D canceled."
      mozconfig-help
      zle send-break
    }
    bindkey '^D' mozconfig-extended-logout
    zle -N mozconfig-extended-logout
  fi
}

local MOZCONFIG_BASEDIR=`dirname $0`
mozconfig-init "$MOZCONFIG_BASEDIR/mozconfigs" $1

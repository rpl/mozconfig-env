#######################################################
## mozconfig-env/fish is not executable!!!
## You need to source it in your current fish session:
##
## . PATH/mozconfig-env/fish MOZCONFIG_NAME
##
#######################################################

function _mozconfig-init
  set -l mozconfig_dir $argv[1]
  set -l mozconfig_name $argv[2]

  function mozconfig-help
    echo -e "Available mozconfig-env commands:"
    echo -e "\t- mozconfig-help        prints this help"
    echo -e "\t- mozconfig-list        prints the available mozconfig environments"
    echo -e "\t- mozconfig-switch NAME switch into the NAME mozconfig environment"
    echo -e "\t- mozconfig-deativate   deactive the mozconfig-env helpers from the session"
    echo -e "\nIf you want to exit the current MOZCONFIG:\n\t\$ mozconfig-deativate"
    echo -e "\nIf you want to switch the current MOZCONFIG:\n\t\$ mozconfig-switch MOZCONFIG_NEW"
    echo -e "\nIf you want to exit the shell:\n\t\$ exit"
  end
  functions -d "prints usage instructions" mozconfig-help

  function mozconfig-list
    set -l mozconfig_available (ls $_mozconfig_dir)
    echo -e "Available MOZCONFIG profiles:"
    echo -e "$mozconfig_available"  | tr " " "\n" | sed "s/^/\t- /g"
  end
  functions -d "prints the available mozconfig environments" mozconfig-list

  ## If mozconfig-switch is already defined,
  ## just switch the MOZCONFIG environment.
  functions -q mozconfig-switch
  if [ $status -eq 0 ]
    mozconfig-switch $mozconfig_name
  else
    mozconfig-help
    set -g _mozconfig_dir $mozconfig_dir
    set -g _mozconfig_name $mozconfig_name

    functions --copy fish_prompt _mozconfig_env_old_fishprompt

    function fish_prompt
      set -l old_prompt (_mozconfig_env_old_fishprompt)
      echo "($_mozconfig_name) $old_prompt"
    end

    function mozconfig-deactivate
      ## Cleanup.
      functions -e _mozconfig-init
      functions -e mozconfig-help
      functions -e mozconfig-list
      functions -e mozconfig-switch
      functions -e mozconfig-deactivate
      set -e _mozconfig_name
      set -e _mozconfig_dir
      set -e MOZCONFIG

      ## Restore the prompt.
      functions -e fish_prompt
      functions --copy _mozconfig_env_old_fishprompt fish_prompt
      functions -e _mozconfig_env_old_fishprompt
    end
    functions -d "deactive the mozconfig-env helpers from the session" mozconfig-deactivate

    function mozconfig-switch
      set -l mozconfig_name $argv[1]
      set -l mozconfig_new "$_mozconfig_dir/$mozconfig_name"

      if [ ! -f "$mozconfig_new" ]
        set_color red
        echo -e "ERROR the new MOZCONFIG does not exist:\n\t$mozconfig_new"
        set_color normal
      else
        set -g _mozconfig_name $mozconfig_name
        set -g MOZCONFIG "$mozconfig_new"
        function fish_prompt
          set -l old_prompt (_mozconfig_env_old_fishprompt)
          echo "($_mozconfig_name) $old_prompt"
        end
      end
    end
    functions -d "switch into the NAME mozconfig environment" mozconfig-switch
  end
end

set -l filename (status -f)
set -l mozconfig_dir (dirname $filename)/mozconfigs
set -l mozconfig_name $argv
set -l mozconfig_new "$mozconfig_dir/$mozconfig_name"

if [ ! -f "$mozconfig_dir/$mozconfig_name" ]
  set_color red
  echo "ERROR the requested MOZCONFIG does not exist:\n\t$mozconfig_new"
  set_color normal
else
  _mozconfig-init $mozconfig_dir $mozconfig_name
end

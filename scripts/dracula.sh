#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

get_tmux_option() {
	local option=$1
	local default_value=$2
	local option_value=$(tmux show-option -gqv "$option")
	if [ -z $option_value ]; then
		echo $default_value
	else
		echo $option_value
	fi
}

main()
{
	# set current directory variable
	current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

  # set configuration option variables
  show_flags=$(get_tmux_option "@dracula-show-flags" false)
  show_left_icon=$(get_tmux_option "@dracula-show-left-icon" smiley)
  show_left_icon_padding=$(get_tmux_option "@dracula-left-icon-padding" 1)
  show_left_sep=$(get_tmux_option "@dracula-show-left-sep" )
  show_right_sep=$(get_tmux_option "@dracula-show-right-sep" )
  show_border_contrast=$(get_tmux_option "@dracula-border-contrast" false)
  show_refresh=$(get_tmux_option "@dracula-refresh-rate" 5)

  # Dracula Color Pallette
  bglight='#343746'
  bg='#282A36'
  bgdark="#21222C"
  white='#f8f8f2'
  white_shade_4='#949491'
  gray='#44475a'
  dark_gray='#282a36'
  light_purple='#bd93f9'
  dark_purple='#6272a4'
  cyan='#8be9fd'
  green='#50fa7b'
  orange='#ffb86c'
  red='#ff5555'
  pink='#ff79c6'
  yellow='#f1fa8c'


  # Handle left icon configuration
  case $show_left_icon in
	  smiley)
		  left_icon="☺";;
	  session)
		  left_icon="#S";;
	  window)
		  left_icon="#W";;
	  *)
		  left_icon=$show_left_icon;;
  esac

  # Handle left icon padding
  padding=""
  if [ "$show_left_icon_padding" -gt "0" ]; then
	  padding="$(seq -f " " -s '' $show_left_icon_padding)"
  fi
  left_icon="$left_icon$padding"

  case $show_flags in
	  false)
		  flags=""
		  current_flags="";;
	  true)
		  flags="#{?window_flags,#[fg=${dark_purple}]#{window_flags},}"
		  current_flags="#{?window_flags,#[fg=${light_purple}]#{window_flags},}"
  esac

  # sets refresh interval to every 5 seconds
  tmux set-option -g status-interval $show_refresh

  # set length
  tmux set-option -g status-left-length 100
  tmux set-option -g status-right-length 100

  # pane border styling
  if $show_border_contrast; then
	  tmux set-option -g pane-active-border-style "fg=${light_purple}"
	  tmux set-option -g pane-border-style "fg=${light_purple}"
  else
	  tmux set-option -g pane-active-border-style "fg=${dark_purple}"
	  tmux set-option -g pane-border-style "fg=${dark_purple}"
  fi

  # mode style
  tmux set-option -g mode-style "fg=$color_red,bg=$color_orange"

  # command line style; for typing tmux commands
  tmux set-option -g message-style "fg=$color_main,bg=$color_purple"

  # status line style
  tmux set-option -g status-style "fg=$gray,bg=$bgdark"

  tmux set-option -g status-left "#[bg=${green},fg=${dark_gray}]#{#[bg=${yellow}],} ${left_icon} "

  # "tabs"
  tmux set-window-option -g window-status-current-style "fg=${dark_gray},bg=${cyan}"
  tmux set-window-option -g window-status-current-format "→ #I:#W ←"
  tmux set-window-option -g window-status-style "fg=${cyan},bg=${dark_purple}"
  tmux set-window-option -g window-status-format " #I:#W "
  tmux set-window-option -g window-status-activity-style "bold"
  tmux set-window-option -g window-status-bell-style "bold"

  #set inactive/active window styles
  tmux set-option -g window-style "fg=$white_shade_4,bg=$bg"
  tmux set-option -g window-active-style "fg=$white,bg=$bglight"

}

# run main function
main

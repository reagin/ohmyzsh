# This theme is modified from half-life.zsh-theme

# use extended color palette if available
if [[ $TERM = (*256color|*rxvt*) ]]; then
  green="%{${(%):-"%F{118}"}%}"
  orange="%{${(%):-"%F{166}"}%}"
  purple="%{${(%):-"%F{135}"}%}"
  hotpink="%{${(%):-"%F{161}"}%}"
  turquoise="%{${(%):-"%F{81}"}%}"
else
  green="%{${(%):-"%F{green}"}%}"
  orange="%{${(%):-"%F{yellow}"}%}"
  purple="%{${(%):-"%F{magenta}"}%}"
  hotpink="%{${(%):-"%F{red}"}%}"
  turquoise="%{${(%):-"%F{cyan}"}%}"
fi

autoload -Uz vcs_info
# enable VCS systems you use
zstyle ':vcs_info:*' enable git svn
# you should disable it, if you work with large repositories
zstyle ':vcs_info:*:prompt:*' check-for-changes true

# set prompt formats below
# %b - branchname
# %u - unstagedstr (see below)
# %c - stagedstr (see below)
# %a - action (e.g. rebase-i)
# %R - repository path
# %S - path in the repository
PR_RST="%{${reset_color}%}"
FMT_BRANCH=" on ${turquoise}%b%u%c${PR_RST}"
FMT_ACTION=" performing a ${green}%a${PR_RST}"
FMT_STAGED="${green} ●"
FMT_UNSTAGED="${orange} ●"

zstyle ':vcs_info:*:prompt:*' unstagedstr   "${FMT_UNSTAGED}"
zstyle ':vcs_info:*:prompt:*' stagedstr     "${FMT_STAGED}"
zstyle ':vcs_info:*:prompt:*' actionformats "${FMT_BRANCH}${FMT_ACTION}"
zstyle ':vcs_info:*:prompt:*' formats       "${FMT_BRANCH}"
zstyle ':vcs_info:*:prompt:*' nvcsformats   ""

function steeef_chpwd {
  PR_GIT_UPDATE=1
}

function steeef_preexec {
  case "$2" in
  *git*|*svn*) PR_GIT_UPDATE=1 ;;
  esac
}

function steeef_precmd {
  (( PR_GIT_UPDATE )) || return

  # check for untracked files or updated submodules, since vcs_info doesn't
  if [[ -n "$(git ls-files --other --exclude-standard 2>/dev/null)" ]]; then
    PR_GIT_UPDATE=1
    FMT_BRANCH="${PM_RST} on ${turquoise}%b%u%c${hotpink} ●${PR_RST}"
  else
    FMT_BRANCH="${PM_RST} on ${turquoise}%b%u%c${PR_RST}"
  fi

  zstyle ':vcs_info:*:prompt:*' formats     "${FMT_BRANCH}"
  vcs_info 'prompt'
  PR_GIT_UPDATE=
}

# vcs_info running hooks
PR_GIT_UPDATE=1

autoload -U add-zsh-hook
add-zsh-hook chpwd steeef_chpwd
add-zsh-hook precmd steeef_precmd
add-zsh-hook preexec steeef_preexec

# ruby prompt settings
ZSH_THEME_RUBY_PROMPT_PREFIX="with%F{red} "
ZSH_THEME_RUBY_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_RVM_PROMPT_OPTIONS="v g"

# virtualenv prompt settings
ZSH_THEME_VIRTUALENV_PREFIX=" with%F{red} "
ZSH_THEME_VIRTUALENV_SUFFIX="%{$reset_color%}"

setopt prompt_subst

# Concatenate prompts
if [[ $EUID -eq 0 ]]; then
  PROMPT="${hotpink}%n%{$reset_color%}"
else
  PROMPT="${purple}%n%{$reset_color%}"
fi

PROMPT="${PROMPT} in ${green}%c%{$reset_color%}\$(virtualenv_prompt_info)\$(ruby_prompt_info)\$vcs_info_msg_0_${orange} λ%{$reset_color%} "

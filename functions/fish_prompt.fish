function fish_prompt
    set -l __last_command_exit_status $status

    if not set -q -g __fish_prompt_functions_defined
        set -g __fish_prompt_functions_defined

        function _is_git_repo
            type -q git
            or return 1
            git rev-parse --git-dir >/dev/null 2>&1
        end

        function _is_hg_repo
            fish_print_hg_root >/dev/null
        end

        function _repo_type
            if _is_hg_repo
                echo hg
                return 0
            else if _is_git_repo
                echo git
                return 0
            end
            return 1
        end
    end

    set -l cyan (set_color -o cyan)
    set -l yellow (set_color -o yellow)
    set -l red (set_color -o red)
    set -l green (set_color -o green)
    set -l blue (set_color -o blue)
    set -l normal (set_color normal)

    set -l arrow_color "$green"
    if test $__last_command_exit_status != 0
        set arrow_color "$red"
    end

    set -l arrow "$arrow_color❯ "
    if fish_is_root_user
        set arrow "$arrow_color# "
    end

    set -l cwd (prompt_pwd --full-length-dirs=10)

    if set -l repo_type (_repo_type)
        echo $arrow_color$arrow$normal
    else
        echo $arrow_color$cwd$arrow$normal
    end
end

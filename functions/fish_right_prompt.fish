function fish_right_prompt
    if not set -q -g __fish_prompt_right_functions_defined
        set -g __fish_prompt_right_functions_defined
        function _git_branch_name
            set -l branch (git symbolic-ref --quiet HEAD 2>/dev/null)
            if set -q branch[1]
                echo (string replace -r '^refs/heads/' '' $branch)
            else
                echo (git rev-parse --short HEAD 2>/dev/null)
            end
        end

        function _is_git_dirty
            not command git diff-index --cached --quiet HEAD -- &>/dev/null
            or not command git diff --no-ext-diff --quiet --exit-code &>/dev/null
        end

        function _is_git_staged
            not git diff --cached --exit-code >/dev/null 2>&1
        end

        function _is_git_repo
            type -q git
            or return 1
            git rev-parse --git-dir >/dev/null 2>&1
        end

        function _hg_branch_name
            echo (hg branch 2>/dev/null)
        end

        function _is_hg_dirty
            set -l stat (hg status -mard 2>/dev/null)
            test -n "$stat"
        end

        function _is_hg_repo
            fish_print_hg_root >/dev/null
        end

        function _repo_branch_name
            _$argv[1]_branch_name
        end

        function _is_repo_dirty
            _is_$argv[1]_dirty
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

    set -l gray (set_color -d white)
    set -l normal (set_color -o normal)
    set -l cwd (prompt_pwd | path basename)

    if set -l repo_type (_repo_type)
        set -l repo_branch (_repo_branch_name $repo_type)
        
        set -l status_info
        if _is_repo_dirty $repo_type
            set status_info !
        end
        if _is_git_staged
            set status_info +$status_info
        end

        set -l repo_info $status_info $cwd/$repo_type/$repo_branch
        echo $gray$repo_info$normal
    end
end

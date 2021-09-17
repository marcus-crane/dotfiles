function tangle -d "Tangle org mode file using Emacs"
    command emacs --batch -l org $argv -f org-babel-tangle
end

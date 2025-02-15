set seed (random 1 1 6)

function fishy_fish
    echo '                 '(set_color F00)'___
    ___======____='(set_color FF7F00)'-'(set_color FF0)'-'(set_color FF7F00)'-='(set_color F00)') /T            \_'(set_color FF0)'--='(set_color FF7F00)'=='(set_color F00)')    '(set_color red)(whoami)'
    [ \ '(set_color FF7F00)'('(set_color FF0)'0'(set_color FF7F00)')   '(set_color F00)'\~    \_'(set_color FF0)'-='(set_color FF7F00)'='(set_color F00)')'(set_color yellow)'    
    \      / )J'(set_color FF7F00)'~~    \\'(set_color FF0)'-='(set_color F00)')    
    \\\\___/  )JJ'(set_color FF7F00)'~'(set_color FF0)'~~   '(set_color F00)'\)     '(set_color yellow)'Fish '(set_color white)(echo $FISH_VERSION)(set_color red)'
    \_____/JJJ'(set_color FF7F00)'~~'(set_color FF0)'~~    '(set_color F00)'\\
	'(set_color FF7F00)'/ '(set_color FF0)'\  '(set_color FF0)', \\'(set_color F00)'J'(set_color FF7F00)'~~~'(set_color FF0)'~~     '(set_color FF7F00)'\\
	(-'(set_color FF0)'\)'(set_color F00)'\='(set_color FF7F00)'|'(set_color FF0)'\\\\\\'(set_color FF7F00)'~~'(set_color FF0)'~~       '(set_color FF7F00)'L_'(set_color FF0)'_
    '(set_color FF7F00)'('(set_color F00)'\\'(set_color FF7F00)'\\)  ('(set_color FF0)'\\'(set_color FF7F00)'\\\)'(set_color F00)'_           '(set_color FF0)'\=='(set_color FF7F00)'__
    '(set_color F00)'\V    '(set_color FF7F00)'\\\\'(set_color F00)'\) =='(set_color FF7F00)'=_____   '(set_color FF0)'\\\\\\\\'(set_color FF7F00)'\\\\
	'(set_color F00)'\V)     \_) '(set_color FF7F00)'\\\\'(set_color FF0)'\\\\JJ\\'(set_color FF7F00)'J\)
    '(set_color F00)'/'(set_color FF7F00)'J'(set_color FF0)'\\'(set_color FF7F00)'J'(set_color F00)'T\\'(set_color FF7F00)'JJJ'(set_color F00)'J)
    (J'(set_color FF7F00)'JJ'(set_color F00)'| \UUU)
    (UU)'(set_color normal)
end


if [ $seed -eq 1 ]
    function fish_greeting
	fishy_fish
    end
else if [ $seed -eq 2 ]
    function fish_greeting
	if [ -d ~/.alan ]
		neofetch
	else
		cbonsai -p -m "$USER@$COMPANY; fish: $FISH_VERSION"
	end
    end
else if [ $seed -eq 3 ]
    function fish_greeting
	fortune | cowsay | lolcat
    end
else if [ $seed -eq 4 ]
    function fish_greeting
	neofetch
    end
else
    function fish_greeting
	if [ -d ~/.alan ]
		neofetch
	else
		now
	end
    end
end

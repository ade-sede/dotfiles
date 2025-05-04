function silent_lolcat
    lolcat 2>/dev/null
end

function fish_greeting
    set greeting_option (random 1 8)

    switch $greeting_option
        case 1
	    if test (random 0 1) -eq 1
	        cbonsai | silent_lolcat
	    else
	        cbonsai
	    end
        case 2
            set quotes (fortune)
            
            set animal_options "default" "tux" "stegosaurus" "dragon" "sheep" "elephant" "moose" "koala"
            set random_animal $animal_options[(random 1 (count $animal_options))]
            
            set box_designs cat dog bear mouse
            set random_box $box_designs[(random 1 (count $box_designs))]
            
            set text_formatters figlet "boxes -d $random_box" "cowsay -f $random_animal"
            set selected_formatter $text_formatters[(random 1 (count $text_formatters))]
            if test (random 0 1) -eq 1
                echo $quotes | eval $selected_formatter | silent_lolcat
            else
                echo $quotes | eval $selected_formatter
            end
        case 3
            doge
        case 4
            neofetch
        case 5
	    cmatrix -s -C blue -u 9 -B
        case 6
	    set sl_options d g w l a f
	    set random_options ""
	    set random_options "$random_options -e"
	    for opt in $sl_options
	        if test (random 0 1) -eq 1
	            set random_options "$random_options -$opt"
	        end
	    end
	    if test "$random_options" = "-e"
	        set random_opt $sl_options[(random 1 (count $sl_options))]
	        set random_options "$random_options -$random_opt"
	    end
	    eval "sl $random_options"
        case 7
	    asciiquarium
        case 8
	    nyancat
	case '*'
	    if test (random 0 1) -eq 1
	        echo "Oopsy, no greeting found" | figlet | silent_lolcat
	    else
	        echo "Oopsy, no greeting found" | figlet
	    end
    end
end

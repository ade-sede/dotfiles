function fish_greeting
    set quotes (fortune)
    if test $status -ne 0
        set quotes "Welcome back!"
    end
    
    set animal_options "default" "tux" "stegosaurus" "dragon" "sheep" "elephant" "moose" "koala"
    set random_animal $animal_options[(random 1 (count $animal_options))]
    
    set greeting_option (random 1 10)
    
    switch $greeting_option
        case 1
            if test (random 1 3) -eq 1
                cbonsai | lolcat
            else
                cbonsai
            end
        case 2
            echo $quotes | cowsay -f $random_animal | lolcat
        case 3
            echo $quotes | figlet | lolcat
        case 4
            cmatrix -s -C blue -u 9 -B
        case 5
            sl
        case 6
            if type -q asciiquarium
                asciiquarium -c -t 3
            else
                echo $quotes | cowsay -f $random_animal | lolcat
            end
        case 7
            if type -q nyancat
                nyancat -t 3
            else
                echo $quotes | cowsay -f $random_animal | lolcat
            end
        case 8
            echo $quotes | boxes -d dog | lolcat
        case 9
            if type -q doge
                doge
            else
                echo $quotes | cowsay -f $random_animal | lolcat
            end
        case 10
            neofetch
    end
end
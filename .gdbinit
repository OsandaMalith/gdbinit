# Flags util (for .gdbinit)
# set of commands for easy manipulation on FLAGS
# CC-BY: hasherezade
# Modified by: @OsandaMalith
# Added options for setting and unsetting flags

define translate_flag
    if $argc == 0
        help translate_flag
    else
    set $retval = (-1)
        if $arg0 == 'O'
            set $retval = 0xB
        end
        if $arg0 == 'D'
            set $retval = 0xA
        end
        if $arg0 == 'I'
            set $retval = 0x9
        end
        if $arg0 == 'T'
            set $retval = 0x8
        end
        if $arg0 == 'S'
            set $retval = 0x7
        end
        if $arg0 == 'Z'
            set $retval = 0x6
        end
        if $arg0 == 'A'
            set $retval = 0x4
        end
        if $arg0 == 'P'
            set $retval = 0x2
        end
        if $arg0 == 'C'
            set $retval = 0x0
        end
    end
end
document translate_flag
Use: translate_flag <arg>
    Translates a flag name(represented by char) into the mask that can be applied to on eflags, i.e:
    'O' -> 0xB, 'D' -> 0xA, ... , 'C' -> 0x0
    example:
        translate_flag 'Z' (returns 6)
end

define check_flag_num
    if $argc == 0
        set $retval = (-1)
        help check_flag_num
    else
        if ($eflags >> $arg0) & 1
            set $retval = 1
            printf "[X]"
        else
            set $retval = 0
            printf "[ ]"
        end
    end
end
document check_flag_num
Use: check_flag_num <arg>
    Checks if the flag (defined by mask) is set
end

define check_flag
    if $argc == 0
        set $retval = (-1)
        help check_flag
    else
        translate_flag $arg0
        check_flag_num $retval
    end
end
document check_flag
Use: check_flag <arg>
    Checks if the flag (defined by name) is set
end

define flags
    printf " O  D  I  T  S  Z  *  A  *  P  *  C \n"
    set $flag = 0xB
    while $flag >= 0
        check_flag_num $flag
        set $flag = $flag - 1
    end
    printf "\n"
end
document flags
    Prints flags
end

define neg_flag_num
    if $argc == 0
        help neg_flag_num
    end

    if $arg0 < 0 || $arg0 > 0x0B || $arg0 == 1 || $arg0 == 3 || $arg0 == 5
        printf "Invalid flag mask!\n"
    else
        set $val = 1 << $arg0
        set ($ps)^=$val
        flags
    end
end
document neg_flag_num
Use : neg_flag_num <arg>
    Negates value of the flag, defined by its mask
    example:
        neg_flag_num 6 (negates ZF)
end

define neg_flag
    set $flag_offset = (-1)
    if $argc > 0
        translate_flag $arg0
        set $flag_offset = $retval
    end
    if $flag_offset == (-1)
        printf "Invalid flag supplied!\n"
        help neg_flag
    else
        neg_flag_num $flag_offset
    end
end
document neg_flag
Use: neg_flag <arg>
    Negates value of the flag, defined by its name: (O  D  I  T  S  Z  A  P  C)
    example:
        neg_flag 'Z' (negates ZF)
end

define set_flag_num
    if $argc == 0
        help set_flag_num
    end

    if $arg0 < 0 || $arg0 > 0x0B || $arg0 == 1 || $arg0 == 3 || $arg0 == 5
        printf "Invalid flag mask!\n"
    else
        set $val = 1 << $arg0
        set ($ps) |= $val
        flags
    end
end

document set_flag_num
Use : set_flag_num <arg>
    Sets the value of the flag, defined by its mask
    example:
        set_flag_num 6 (Sets ZF)
end

define set_flag
    set $flag_offset = (-1)
    if $argc > 0
        translate_flag $arg0
        set $flag_offset = $retval
    end
    if $flag_offset == (-1)
        printf "Invalid flag supplied!\n"
        help set_flag
    else
        set_flag_num $flag_offset
    end
end

document set_flag
Use: set_flag <arg>
    Sets the value of the flag, defined by its name: (O  D  I  T  S  Z  A  P  C)
    example:
        set_flag 'Z' (Sets ZF)
end



define unset_flag_num
    if $argc == 0
        help unset_flag_num
    end

    if $arg0 < 0 || $arg0 > 0x0B || $arg0 == 1 || $arg0 == 3 || $arg0 == 5
        printf "Invalid flag mask!\n"
    else
        set $val = 1 << $arg0
        set ($ps)&=~$val
        flags
    end
end

document unset_flag_num
Use : unset_flag_num <arg>
    Unsets the value of the flag, defined by its mask
    example:
        unset_flag_num 6 (unsets ZF)
end


define unset_flag
    set $flag_offset = (-1)
    if $argc > 0
        translate_flag $arg0
        set $flag_offset = $retval
    end
    if $flag_offset == (-1)
        printf "Invalid flag supplied!\n"
        help unset_flag
    else
        unset_flag_num $flag_offset
    end
end

document unset_flag
Use: unset_flag <arg>
    Unsets the value of the flag, defined by its name: (O  D  I  T  S  Z  A  P  C)
    example:
        unset_flag 'Z' (unsets ZF)       
end

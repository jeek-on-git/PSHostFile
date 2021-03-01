Switch -file $file {
    '^[0-9]+.' {'IP'}
    $patternCommented {'Comment'}
    # default {$_} 
}



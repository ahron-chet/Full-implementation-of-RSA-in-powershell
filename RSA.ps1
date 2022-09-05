function intToByete23($n,$len)
{
    $b = @()
    $l = $len - 1
    $m = $n
    for ($i=0; $i-lt$l;$i++)
    {
        $c = div256($n)

        if (((power -x 256 -y ($l-$i))*$c) -lt $n)
        {
            $n-=[bigint]((power -x 256 -y ($l-$i))*$c)
            $b += $c
        }
        else
        {
            $b+=0
        }
    }
    $b = $b + ($m % 256)
    return $b
}


function pow-mod($x,$y,$z)
{
    $n = [bigint]1
    $x = [bigint]$x
    $y = [bigint]$y
    $z = [bigint]$z
    while ($y -gt 0)
    {
        if (-not($y % 2 -eq 0))
        {
            $n = $n * $x % $z
        }
        $y = $y -shr 1
        $x = $x * $x % $z
    }
    return $n
}

function is-prime($n)
{

    $primes = (2,3,5)
    if ($n -eq 0)
    {
        return $false
    }
    if ($n -eq 1)
    {
        return $false
    }
    if ($primes.Contains($n))
    {
        $true
    }
    if ($n -lt 5)
    {
        return $false
    }

    if ($n % ($n -shr 1) -eq 0)
    {
        return $false
    }
    for ($i=2; $i-lt([Math]::SQRT($n)+1);$i++)
    {
        if ($n % $i -eq 0)
        {
            return $false
        }
    }
    return $true

}

function power($x,$y)
{
    $n = [bigint]1
    $x = [bigint]$x
    $y = [bigint]$y
    for ($i=0; $i-lt$y; $i++)
    {
        $n=$n*$x
    }
    return $n
}


function div2($n)
{
    $e = $n-1
    $m = 0
    while ($e%2 -eq 0)
    {
        $e = $e -shr1
        $m = $m + 1
    }
    return $e, $m
    
}
function iterat($a, $e, $m, $n)
{
    $a=[bigint]$a
    $e=[bigint]$e
    $m=[bigint]$m
    $n=[bigint]$n
    if ((pow-mod -x $a -y $e -z $n) -eq 1)
    {
        return $true
    }
    for ($i=0; $i-lt $m; $i++)
    {
        $y = (power -x 2 -y $i)*$e
        $t = pow-mod -x $a -y $y -z $n
        if ($t -eq $n-1)
        {
            return $true
        }       
    }
    return $false

}
function miler-rabin($n)
{
    $em = (div2 -n $n)
    $e = [bigint]$em[0]
    $m = [bigint]$em[1]
    $n = [bigint]$n
    for ($i=0;$i-lt 20; $i++)
    {
        $a = Get-Random -Minimum 2 -Maximum $n
        if (-not(iterat -a $a -e $e -m $m -n $n))
        {
            return $false
        }
    }
    return $true
}

function random-bit($nbi)
{
    $min = [bigint]$nbi -1
    $max = [bigint]$nbi
    $r=Get-Random -Minimum ((power -x 2 -y $min)+1) -Maximum ((power -x 2 -y $max)-1)
    return [bigint]$r+1
}

function get-prime2($nbit)
{
    $primes = @(2)
    for ($i=3; $i-lt 1000; $i++)
    {
        if (is-prime -n $i)
        {
            $primes+=$i
        }
    }
    while ($true)
    {
        $p = (random-bit -nbi $nbit)
        $p = [bigint]$p
        $c=0
        foreach($t in $primes)
        {
            $t = [bigint]$t
            if ($p % $t -eq [bigint]0)
            {
                $c=1
                break
            }
        }
        if ($c -eq 0)
        {
            $prime = (miler-rabin -n $p)
            if ($prime)
            {
                return $p
            }
        }
    }
}

function round-int($decimel)
{
    $t=$decimel.ToString()
    $res=$t.Split('.')[0]
    return [bigint]$res
}

class Euclids
{
    [bigint]gcd ($a,$b)
   {
        $r=[bigint]0
        while ($true)
        {
            if($a-eq 0 -or $b -eq 0)
            {
                break
            }
            $na=$a
            $nb=$b
            $a = $na % $nb
            $b = $nb % $na
            $r = $b + $a 
        }
        return $r
   }
   
   [array]gcdx ($a,$b)
   {
        #$r=[bigint]0
        if ($a -eq 0)
        {
            return $b,0,1
        }
        $r = [bigint] $b%$a
        $g = [Euclids]::new().gcdx($r,$a)
        $r = [bigint]$g[0]
        $x1 = [bigint]$g[1]
        $y1 = [bigint]$g[2]
        $x = [bigint]$y1 - (round-int($b/$a)) * $x1
        $y = [bigint]$x1
        return $r,$x,$y
   }
}

function intToByetes($n,$len)
{
    function div-b($nb)
    {
        $nb = [bigint]$n
        while($nb -gt 256)
        {
            $nb = [bigint]$n/[bigint]256
        }
        return [bigint]$nb
    }
    $b = @()
    $m = $n % 256
    $nlen=$len-1
    for($i=0; $i-lt$nlen;$i++)
    {
        $c = div-b -nb $n
        if (((power -x 256 -y ($l-$i))*$c )-lt $n)
        {
            $n = $n -((power -x 256 -y ($l-$i))*$c)
            $b = $b + $c
        }
        else
        {
            $b = $b + 0
        }
    }
    $b+=$m

}

function len-arr($r)
{
    $c=0
    foreach($i in $r)
    {
        $c+=1
    }
    return [bigint]$c
}
function bytes-toInt($bytesarray)
{
    $c = len-arr($bytesarray)
    $c = [bigint]$c -1
    $n = 0
    for ($i=0;-not($i-gt$c);$i++)
    {
        Write-Host($i)
        $m = power -x 256 -y ($c-$i)
        $b = [bigint]$bytesarray[$i]
        $r = [bigint]$m*$b
        $n += $r
    }
    return [bigint]$n
}

function str-toBytes($data)
{
    $encode = [system.Text.Encoding]::UTF8
    return $encode.GetBytes($data)
}


function bit-length($n)
{
    $c = [bigint]1
    while ($n -gt 255)
    {
        $n = round-int($n/256)
        $c=$c+[bigint]1
    }
    return $c
}

class RSA
{
    [array]genPrivateKey($nbit)
    {
        $e = [bigint] 65537
        $p = get-prime2 -nbit $nbit
        $q = get-prime2 -nbit $nbit
        $n = [bigint] $q*$p
        $phi = [bigint]($p-1)*($q-1)
        $x = [Euclids]::new().gcdx($e,$phi)[1]
        $d = [bigint]$phi+$x
        $public = @($e,$n)
        $private = @($e,$p,$q,$n,$d)
        return @($public,$private)  
    }

    [bigint]encrypt($public,$m)
    {
        $e = [bigint] $public[0]
        $n = [bigint] $public[1]
        $enc = pow-mod -x $m -y $e -z $n
        return $enc
    }
    [bigint]decrypt($private,$m)
    {
        $d = $private[-1]
        $n = $private[-2]
        $dec = pow-mod -x $m -y $d -z $n
        return $dec
    }
    [string]encryptData($public,$data)
    {
        $data = str-toBytes($data)
        $m = bytes-toInt($data)
        $enc = [RSA]::new().encrypt($public,$m)
        $bitlen = bit-length($enc)
        $enc = intToByetes -n $enc -len $bitlen
        return [System.Convert]::ToBase64String($enc) 
    }
    [string]decryptData($public,$data)
    {
        $m = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($data))
        $m = bytes-toInt($m)
        $dec = [RSA]::new().decrypt($public,$m)
        $bitlen = bit-length($dec)
        $dec = intToByetes -n $dec -len $bitlen
        return $dec
    }

    [string]signature($private,$message)
    {
        $d = $private[2]
        $n = $private[3]
        $hasher = [System.Security.Cryptography.HashAlgorithm]::Create('sha256')
        $hash = $hasher.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($message))
        $hash = bytes-toInt($hash)
        $s = pow-mod -x $hash -y $d -z $n
        $s = intToByetes -n $s -len 32
        return [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($s))
    }


    [string]verifySignature($public,$signature,$message)
    {
        $e = [bigint] $public[0]
        $n = [bigint] $public[1]
        $hasher = [System.Security.Cryptography.HashAlgorithm]::Create('sha256')
        $hash = $hasher.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($message))
        $hash = bytes-toInt($hash)
        $m = bytes-toInt($message)
        if ((pow-mod -x $m -y $e -z $n) -eq $hash)
        {
            return $true
        }
        return $false
    }

}



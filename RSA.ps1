function pow-mod($x,$y,$z)
{
    $n = [System.Numerics.BigInteger]1
    $x = [System.Numerics.BigInteger]$x
    $y = [System.Numerics.BigInteger]$y
    $z = [System.Numerics.BigInteger]$z
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


function power($x,$y)
{
    $n = [System.Numerics.BigInteger]::Parse("1")
    for ($i=0; $i-lt$y; $i++)
    {
        $n=$n*$x
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
    $a=[System.Numerics.BigInteger]$a
    $e=[System.Numerics.BigInteger]$e
    $m=[System.Numerics.BigInteger]$m
    $n=[System.Numerics.BigInteger]$n
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
    $e = [System.Numerics.BigInteger]$em[0]
    $m = [System.Numerics.BigInteger]$em[1]
    $n = [System.Numerics.BigInteger]$n
    for ($i=0;$i-lt 20; $i++)
    {
        $a = GetRandomRange -min 2 -max $n
        if (-not(iterat -a $a -e $e -m $m -n $n))
        {
            return $false
        }
    }
    return $true
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
        $p = [System.Numerics.BigInteger]$p
        $c=0
        foreach($t in $primes)
        {
            $t = [System.Numerics.BigInteger]$t
            if ($p % $t -eq [System.Numerics.BigInteger]0)
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

function GetRandomRange($min,$max){
    $min = [System.Numerics.BigInteger]::Parse($min)
    $max = [System.Numerics.BigInteger]::Parse($max)
    $r = [System.Numerics.BigInteger]::Parse(([System.Numerics.BigInteger](Get-Random -Minimum $min -Maximum $max)))
    return $r
}

function random-bit($nbi)
{
    $min = [System.Numerics.BigInteger]$nbi -1
    $max = [System.Numerics.BigInteger]$nbi
    $r = GetRandomRange -min ((power -x 2 -y $min)+1) -max ((power -x 2 -y $max)-1)
    return [System.Numerics.BigInteger]::Add($r,1)
}


class Euclids
{
    [System.Numerics.BigInteger]gcd ($a,$b)
   {
        $r=[System.Numerics.BigInteger]0
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
        #$r=[System.Numerics.BigInteger]0
        if ($a -eq 0)
        {
            return $b,0,1
        }
        $r = [System.Numerics.BigInteger] $b%$a
        $g = [Euclids]::new().gcdx($r,$a)
        $r = [System.Numerics.BigInteger]$g[0]
        $x1 = [System.Numerics.BigInteger]$g[1]
        $y1 = [System.Numerics.BigInteger]$g[2]
        $x = [System.Numerics.BigInteger]$y1 - ([System.Numerics.BigInteger]::Divide($b,$a)) * $x1
        $y = [System.Numerics.BigInteger]$x1
        return $r,$x,$y
   }
}


class BitConvert 
{
    hidden [System.Numerics.BigInteger]div256($n)
    {
        while(($n -gt 256 )-or ($n -eq 256)){
            $n = [System.Numerics.BigInteger]$n/256
        }
        return [System.Numerics.BigInteger]$n
    }

    [System.Numerics.BigInteger]getBitLen([System.Numerics.BigInteger]$n){
        $c = 1
        while(($n -gt 256 )-or ($n -eq 256)){
            $n = [System.Numerics.BigInteger]::Divide($n,256)
            $c += 1
        }
        return $c
    }

    [array]intToByete($n,$len){
        $y = $this.getBitLen($n)
        if ($y -ne $len){
            throw [System.Exception] "Number is too large for the specified length."
        }
        $b = @()
        $l = $len-1
        $m = $n
        for ($i=0; $i-lt$l;$i++)
        {
            $c = $this.div256($n)
            $check = ((power -x 256 -y ($l-$i))*$c)
            if ($check -lt $n){
                $n-=$check
                $b += $c
            }else{
                $b += $c % 256
            }
        }
        $b = $b + ($m % 256)
        return $b
    }

    [System.Numerics.BigInteger]bytesToInt($bytesarray)
    {
        $c = $bytesarray.Length
        $c = [System.Numerics.BigInteger]$c -1
        $n = 0
        for ($i=0;-not($i-gt$c);$i++)
        {
            $m = power -x 256 -y ($c-$i)
            $r = [System.Numerics.BigInteger]::Multiply($m,[System.Numerics.BigInteger]$bytesarray[$i])
            $n = [System.Numerics.BigInteger]::Add($r,$n)
        }
        return [System.Numerics.BigInteger]$n
    }
}


class RSA
{
    [array]genPrivateKey($nbit)
    {
        $e = [System.Numerics.BigInteger] 65537
        $p = get-prime2 -nbit $nbit
        $q = get-prime2 -nbit $nbit
        $n = [System.Numerics.BigInteger] $q*$p
        $phi = [System.Numerics.BigInteger]($p-1)*($q-1)
        $x = [Euclids]::new().gcdx($e,$phi)[1]
        $d = [System.Numerics.BigInteger]$phi+$x
        $public = @($e,$n)
        $private = @($e,$p,$q,$n,$d)
        return @($public,$private)  
    }

    [System.Numerics.BigInteger]encrypt($public,$m)
    {
        $e = [System.Numerics.BigInteger] $public[0]
        $n = [System.Numerics.BigInteger] $public[1]
        $enc = pow-mod -x $m -y $e -z $n
        return $enc
    }
    [System.Numerics.BigInteger]decrypt($private,$m)
    {
        $d = $private[-1]
        $n = $private[-2]
        $dec = pow-mod -x $m -y $d -z $n
        return $dec
    }
    [string]encryptData($public,$data)
    {
        $con = [BitConvert]::new()
        $m = $con.bytesToInt($data)
        $enc = [RSA]::new().encrypt($public,$m)
        $bitlen = $con.getBitLen($enc)
        $enc = $con.intToByete($enc,$bitlen)
        return [System.Convert]::ToBase64String($enc) 
    }
    [string]decryptData($public,$data)
    {
        $con = [BitConvert]::new()
        $m = [System.Convert]::FromBase64String($data)
        $m = $con.bytesToInt($m)
        $dec = [RSA]::new().decrypt($public,$m)
        $bitlen = $con.getBitLen($dec)
        $dec = $con.intToByete($dec,$bitlen)
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
        $e = [System.Numerics.BigInteger] $public[0]
        $n = [System.Numerics.BigInteger] $public[1]
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




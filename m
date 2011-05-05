From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: how are files allocated on nilfs?
Date: Thu, 05 May 2011 10:43:52 +0900 (JST)
Message-ID: <20110505.104352.179932264.ryusuke@osrg.net>
References: <201105041802.17155.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201105041802.17155.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Wed, 4 May 2011 18:02:16 +0200, dexen deVries wrote:
> Hi,
> 
> a possibly naive question: how are files allocated on nilfs?
> 
> Asking, because I've expected a large-ish (128MB) file to be mostly 
> continuous, modulo segment headers. But it doesn't seem so. A small test to 
> narrow down the question:
>  0) created a new, empty, nilfs, on a separate partition (about 1GB size)
>  1) created a file with dd if=/dev/zero of=a.bin bs=$((128*1024*1024)) count=1
>  2) ran hdparm --fibmap a.bin
> output:
>  byte_offset  begin_LBA    end_LBA    sectors
>          0        231      16446      16216
>      8302592      16503      29094      12592
>     14749696      29239      32830       3592
>     16588800      32895      49214      16320
>     24944640      49255      58158       8904
>     29503488      58327      65598       7272
>     33226752      65663      81982      16320
>     41582592      82007      87230       5224
>     44257280      87415      98366      10952
>     49864704      98431     114750      16320
>     58220544     114759     116302       1544
>     59011072     116503     131134      14632
>     66502656     131191     145374      14184
>     73764864     145519     147518       2000
>     74788864     147583     163902      16320
>     83144704     163951     174446      10496
>     88518656     174607     180286       5680
>     91426816     180351     196670      16320
>     99782656     196703     203518       6816
>    103272448     203695     213054       9360
>    108064768     213119     229438      16320
>    116420608     229455     232590       3136
>    118026240     232783     245822      13040
>    124702720     245887     261662      15776
> 
> 
> while the first chunk of file fills almost whole segment, several subsequent 
> chunks are much smaller than segment. Why is it so?

You can see what's happening easily by using 'dumpseg' tool.

I guess it's because checkpoint is periodically created and some
modified blocks of meta-data are inserted for the checkpoint creation.

For your information, disk layout image of nilfs is found on the page
10 of the following slides:

  http://www.nilfs.org/papers/jls2009-nilfs.pdf


Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

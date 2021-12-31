From: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: couldn't mount because of unsupported optional features (477e7ad1e859f753)
Date: Fri, 31 Dec 2021 21:50:27 +0900
Message-ID: <CAKFNMo=gkj_9wzw+qjmfHr53-4WZeMjSgwHnrDakfTdZkSGdNw@mail.gmail.com>
References: <39575f5e-b47a-d971-6c15-35985a35c9d5@levsen.org>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oixpD7mA6MIIr2h59s8ew94+nhlOIPKVy9b6uYHJmfU=;
        b=dotjDRQ9ZTHWKOtY7Gd7aELWgx9fPrFKb15+3y8jOu0J06byJP0u5enC8OdXFVa8u6
         BzN9F7YRSUFIV0Kzee1Swtq3SVbodFuDxxqPqKWwd1hfz2pi+tF/fyO+aq1MmpX/RG/6
         eEu42sU5EagX87qeQwaWJv1+iy9RkCrLrYVnDJgNJUcXP1daT/UeBB2/xOdOML1msiNw
         9yIlnPrmuXW/mA2FPIEMZGkGvyUWmZ/MxvNQYKDhorG6QHjgtEb18gr0sDPc+FH6u7QL
         jeP1dHJZ+77gd0CzaYTRf24wO0qGC1NimEsUmtjN3pURzEC5nhxk3TPTyxen43PZ2Yen
         GeZw==
In-Reply-To: <39575f5e-b47a-d971-6c15-35985a35c9d5-j5CO6tLloWodnm+yROfE0A@public.gmane.org>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hendrik Levsen <hendrik-j5CO6tLloWodnm+yROfE0A@public.gmane.org>, Peter Grandi <pg-9Cpm1x5jwYpury8xqvH7Iip2UmYkHbXO@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

On Fri, Dec 31, 2021 at 7:16 PM Hendrik Levsen <hendrik-j5CO6tLloWodnm+yROfE0A@public.gmane.org> wrote:
>
> Hi,
>
> Trying to mount a NILFS partition fails with "couldn't mount because of
> unsupported optional features (477e7ad1e859f753)". Neither the OS nor
> the partition have been touched/modified since the last successful install
> mount. Might the underlying block device be corrupt? Is
> "477e7ad1e859f753" a valid set of feature flag?

This value is not valid as the feature flags.
Only 0x00000001 is used for them at present.

The strange thing is that the test of feature flags is done after
validity checks of super blocks (with CRC and a magic number).
So, this type of corruption usually doesn't happen.

NILFS maintains two super blocks, at the beginning and end of the
partition.  If one of them is destroyed, it will be automatically detected
and repaired with a spare.
It seems that something unexpected has happened -  for example,
some external tool or underlying device driver directly overwrote
the super block, and oneline NILFS driver signed CRC against the
broken super block and then wrote it back to the block device unfortunately.

If you inspect further, nilfs-tune command may give some information.
It displays a summary of one of the valid super blocks as follows:

$ sudo nilfs-tune -l /dev/xxxx
nilfs-tune 2.2.5
Filesystem volume name:   (none)
Filesystem UUID:   xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
Filesystem magic number:  0x3434
Filesystem revision #:   2.0
Filesystem features:      (none)
Filesystem state:   valid
Filesystem OS type:   Linux
Block size:   4096
Filesystem created:   Tue Mar  2 20:10:57 2021
Last mount time:   Fri Dec 31 20:52:02 2021
Last write time:   Fri Dec 31 20:52:22 2021
Mount count:   28
Maximum mount count:   50
Reserve blocks uid:   0 (user root)
Reserve blocks gid:   0 (group root)
First inode:   11
Inode size:   128
DAT entry size:   32
Checkpoint size:   192
Segment usage size:   16
Number of segments:   59617
Device size:   500107862016
First data block:   1
# of blocks per segment:  2048
Reserved segments %:   5
Last checkpoint #:   529322
Last block address:   50448632
Last sequence #:   24605
Free blocks count:   110473216
Commit interval:   0
# of blks to create seg:  0
CRC seed:   0xxxxxxxxx
CRC check sum:   0xxxxxxxxx
CRC check data size:   0x00000118


As for recovery, if a spare superblock survives with
valid data, you may be able to repair the file system by manually
erasing the broken one, in theory.   However, this operation
must be done very carefully and is not an intended repair method.
Therefore, I don't recommend it, and I think we should not make it
an usual option.

OTOH, it deserves consideration if there is room for improvement
on the logic or implementation of the tandem method of NILFS
super blocks.

Thanks,
Ryusuke Konishi


>
> Thank you
>
> Hendrik
>

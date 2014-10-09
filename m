From: Hugo Pacheco <hpacheco-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: nilfs-diff experimental branch
Date: Thu, 9 Oct 2014 14:22:46 -0400
Message-ID: <CAFK5svA8x=fx82YAH3Jp3o6kDSO2M=AYNS9ywuCFyOZeXE1Eww@mail.gmail.com>
References: <CAFK5svByXZfnaEMsdiMhrC62tgsMxiAbVFmCcp8KG90=oLc-SQ@mail.gmail.com>
	<20141010.005337.27802719.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=W16OErplLdZsUP5tl6FgWSfJWT7ZoY5aHDq7TyTtH/Y=;
        b=uw0EKALrGyOqugpynu6MmPYAYBYXxGUx0N9xbj3F7cFnU4aTfENErdXac72BltL/y9
         NqRNu1znINGJj2NOQL2AqC4d4RvdvlXJ4MqjYv01XvysLbfh0yOSn+DHBWfiQOVSLceG
         yYSDycfg9FGeytOeenlJIExFlaW6w2NlL0/ou25HXm5EqL9Vy1NXYw5bQkW3I5ohYpDs
         VXVoVcdxanlAPHZ73DeOeKV3SmGiqoFjN94v+kQ/nlVXC7GxcVOCdIw39469PdZU50Kn
         IHigOkJxITVfL/ezBd+bzKpXWppLPiZJLmNFZmEyxqzGjHoTY3vvMhOFdZmAv9IZU8w4
         C9RQ==
In-Reply-To: <20141010.005337.27802719.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Dear Ryusuke-san,

Thank you for the updated code, this was really what I needed.

I have managed to install it successfully on Ubuntu 14.04 by just
adding CFLAGS='-pthread -lm'.

Using the experimental version with reformatted drives, versioning
works fine but unfortunately calls to chcp and nilfs-diff either don't
do anything or hang indefinitely without any error feedback. I am
sorry for bothering, but do you have any clue of what might be
happening? I made sure to unistall all the non-experimental
nilfs-tools beforehand.

Best,
hugo

On Thu, Oct 9, 2014 at 11:53 AM, Ryusuke Konishi
<konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:
> Hi,
> On Wed, 8 Oct 2014 16:53:05 -0400, Hugo Pacheco wrote:
>> Hi everyone,
>>
>> I have been experimenting with the versioning capabilities of nilfs-tools
>> and it works beautifully, but I have now started wanting to explore the
>> hottest features only in the experimental branch, namely nilfs-diff.
>>
>> I understand that this diff branch has never made it to mainstream, and
>> probably won't soon, but has anyone succeeded in installing it for a modern
>> 3.x linux kernel? The latest code available at github seems to require
>> 2.6.x.
>>
>> A more up-to-date picture would be really appreciated.
>
> I rebased diff branches and pushed them out to github:
>
> nilfs-utils  git://github.com/konis/nilfs-utils.git  (diff-v2 branch)
> kernel       git://github.com/konis/nilfs2.git       (diffapi-v2 branch)
>
> These are still experimental and need disk format change.
>
> Regards,
> Ryusuke Konishi



-- 
www.cs.cornell.edu/~hpacheco
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

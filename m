From: Eric Lan <tenoreamer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Feature request: A user-space program listing versioning history
 of a specified file
Date: Sun, 14 Feb 2016 01:58:01 +0800
Message-ID: <CAFm8q6eTX4p_i_w7Nsy3R_5xwS=wQVRTw=vJ4f1j0GRJX0LjuQ@mail.gmail.com>
References: <CAFm8q6eW-3dT7FqmKC3-cg0TpaoKEOt6RCJY86jE9PrK=tZKSQ@mail.gmail.com>
	<CAFm8q6dfuY9_vrqp_H_rePBBLeZc6TBt20G7pEhpzr5eYifQZA@mail.gmail.com>
	<20160213.015824.937707282163873059.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=7s1ayRitHUiRHdBTqQ3S/migx0R5ulGRuEIUDdcRovk=;
        b=rdGEms342Q1YJjsHENcUebruGjkq5zKTI9NyGM6eNGQPAXUfgPGiLhDweuGt4/b0lz
         xSug8TYiPIONG4+12pId8FQv1ZZtQ4yNmdvv4LmoLO4C//jMOBH8B1C7qjYgyJnzSimt
         6RPITw7sVTqeJL1vEujB0Tsm6BDB3hIKuRLbvmbUVe6GT6GXOZa6vfU4QvUEsQ3ep+ly
         2Iq16qAnvghG3LOeyDicdoyqyPe/MkG9S63jaFa7XiKjEWmBMTGM+B+T8WFEG6vv63By
         022TsDEXRyKuBa5A2MlqIHScSclI04F1MPO8CNoaQp2kX2mQqPKPmQb16rqtVdop8ZRb
         5WZw==
In-Reply-To: <20160213.015824.937707282163873059.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

I think these requests, when materialized, would be very useful and
become attractive features for NILFS2 because the natural advantages
(COW & preserving previous versions of files) of NILFS2 become very
convenient for the users to access to recover old versions of or
deleted files.

Actually, I thought it may be possible to use BASH scripting to list
versions of files. The script may work by mounting checkpoints one by
one retrogradely to find the specified files with different mtime
until the absence of the file in a certain checkpoint. But the
performance would be low. How to collect these versions for users to
view easily(without mounting by the user again)? I don't know if it is
possible to make a "hardlink" inode in the current "checkpoint" that
points to an old version of file. This way, the duplication load could
be spared. But I wondered if that would interfere with garbage
collection.

Just sharing some ideas. Anyway, thank you for taking these requests
into consideration ^^

Anticipating,
Eric Lan

2016-02-13 0:58 GMT+08:00 Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>:
> On Fri, 5 Feb 2016 00:59:17 +0800, Eric Lan <tenoreamer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Hello,
>>
>> Recently, I have installed NILFS2 and feel it quite cool. I wonder if
>> you are insterested in developing a program that can trace back all
>> the check points to list the revision history of a specified file.
>> With certain argument specified, these versions of files can be
>> collected into a directory for the user to choose a good one from.
>>
>> Such program may be easily extended to have the function of
>> "undelete". That is, to collect a series of versions of or the most
>> recent version of a specific file that exist only in the past
>> checkpoints.
>
> None of your requests look easy to implement ;)
>
> Anyway, I added them to the todo list at
> http://nilfs.sourceforge.net/en/current_status.html
>
> Thanks,
> Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

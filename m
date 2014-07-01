From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] nilfs2: suggest to use dump_stack() in nilfs_error()
 and nilfs_warning()
Date: Wed, 02 Jul 2014 04:30:31 +0900 (JST)
Message-ID: <20140702.043031.1601160334463833454.konishi.ryusuke@lab.ntt.co.jp>
References: <1404050621.4139.19.camel@slavad-CELSIUS-H720>
	<20140630.040159.120185966358440318.konishi.ryusuke@lab.ntt.co.jp>
	<1404116683.2580.32.camel@slavad-CELSIUS-H720>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=C2m4JN9VuuaHBlrN8vJZY7UvhjpXMxcanvsFWL1B9iQ=;
        b=xoHk7l8Gwtz7DAELXG8pgDmkA/69uQj/VlChKFNrrFMn33L+3f0Uux4lGkYQAnJ/oL
         XHGWld5ZZ2kvA3zc7Pb4CcvfKzOxQgJdLHMUdLfyDbL+2d6FSKiTfiMdMccV20mAgR+y
         NmvOKtFXYFDpOgISzbb5whyKRdCuHryfhUcFGYTB2Wlti5hzmapjwPIHSJWY97L7takS
         ZgAMMWisnCczSxzvJpFcEY/S+P91PTit5WkmwquyZNuGU177iJLvaKiG+UgzSDpqpHnX
         VjhsLoE0yM0QOsSDkAsE6t0CDW5ikdLkhgytSR3KVDbo1aXk4cDbnhFCUQxFU9WmaacE
         GFaA==
In-Reply-To: <1404116683.2580.32.camel@slavad-CELSIUS-H720>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Mon, 30 Jun 2014 12:24:43 +0400, Vyacheslav Dubeyko wrote:
> On Mon, 2014-06-30 at 04:01 +0900, Ryusuke Konishi wrote:
>> On Sun, 29 Jun 2014 18:03:41 +0400, Vyacheslav Dubeyko wrote:
>> > From: Vyacheslav Dubeyko <Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org>
>> > Subject: [PATCH] nilfs2: suggest to use dump_stack() in nilfs_error() and nilfs_warning()
>> > 
>> > This patch suggests to use dump_stack() call in nilfs_error() and
>> > nilfs_warning() for more clear understanding of different type of
>> > issues. As a result, end-users can report more informative
>> > descriptions of issues.
>> > 
>> > Signed-off-by: Vyacheslav Dubeyko <Vyacheslav.Dubeyko-XckBA8eALwE@public.gmane.org>
>> > CC: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
>> > CC: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
>> 
>> NAK.
>> 
>> This patch makes error/warning routine of nilfs so verbose.
>> 
>> dump_stack() should be used for some critical situations or internal
>> inconsisent situtations, or for cases in which the identifying call
>> path of trouble is not easy.
>> 
>> I think it's not used for regular errors or warnings because they are
>> mostly identifiable.
>> 
>> In addition, "errors=panic" mount option is available for nilfs_error
>> to force stack dump.
>> 
> 
> I worry about end-user side. Yes, if developer investigates the issue
> then he has many opportunities for the investigation. But we have very
> frequently end-users' reports with not very informative details. And it
> is not so easy to identify the reason of an issue very frequently. We've
> spent about a year on trying to identify the reason of the issue with
> race condition of competition between segments for dirty blocks. And the
> reason of such situation was impossibility to reproduce the issue easily
> and to understand situation on end-users' side. So, from my point of
> view, it makes sense to show dump_stack() for the case of remount in RO
> mode or any warnings.
> 
> I think that NILFS2 driver contains many places without necessary output
> about errors. For example:
> 
> [160281.690959] nilfs_btree_propagate: key = 10, level == 0
> [160281.690967] NILFS warning (device dm-0): nilfs_clean_segments: 
> segment construction failed. (err=-2)
> 
> Yes, it is possible to understand that we have some error situation on
> segctor side. And somewhere inside of segctor thread took place
> situation with -ENOENT error. But it is really hard to understand the
> place and environment of such situation. I suppose that if we will have
> more detailed error messages output then it will be more easily to
> understand an issue's environment and the reason of it.

The above warning shows that nilfs_clean_segments() function failed
due to -ENOENT error, but it is unclear how and where the error is
created.

Note that inserting dump_stack() in nilfs_warning() doesn't help to
clear this situation.  It will show how nilfs_clean_segments() was
called, but it is almost clear and can easily come to superfluous
information.

Error messages should be inserted or enhanced effectively and
thoughtfully.  Verbose (and useless) information causes overflow of
kernel ring buffer, and can lead to poor or corrupted log messages.

For the above example, adding error messages in error paths of segment
constructor's functions seems better.

> How do you feel about enhancement of output for the case of errors? I
> mean to add messages for such places:
> 
> err = some_func();
> if (err) {
> 	/* add message output here with details */
> 	return err;
> }
> 

It's on a case by case basis whether the enhancement is meaningful or
not.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Viacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [!] Unable to mount nilfs2 filesystem after power outage -
 error loading super root.
Date: Fri, 18 Mar 2016 15:45:07 -0700
Message-ID: <1458341107.2615.27.camel@slavad-ubuntu-14.04>
References: <56EC45FD.7010808@gmail.com>
	 <1458331991.2615.6.camel@slavad-ubuntu-14.04> <56EC67A2.8050905@gmail.com>
	 <1458337014.2615.14.camel@slavad-ubuntu-14.04> <56EC7DCE.1020906@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=igYYOmKrADFmK9f1jYLryzyP+g43AkV2ZJIV8dhndbY=;
        b=dzKS4TB2OK7ZAZf7Z9fVRXNoqmF9XSDHQsFMzzKqbyk8Cuyq00ShMDwVYxtkFaN1Do
         j4dSxpsGaEBsjlHFdcklT4GjITiwxa/OPl6HLmUprbx2ZTdMxVLdqx13NjnQGAKdT7aC
         CsWqDitqFwba7NJdX9fTEY7sI+C3mQLkqjy3Y2+ijOfVhkmbY0sp1yAg38hfysCxKEIw
         Y/4fLsqwLXThEgGNAitXDUqKvAJLtVRaK7wxqEIymVARDMB2YEuDYUzKvR+FtgdkW7ze
         Ekx/of8nL/yWnuo1yh0Ywl5TbBAb6BFV4Z3xKR+hgJvKJiTaZfjkQilg2J2mEP5nQvai
         EwPA==
In-Reply-To: <56EC7DCE.1020906-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: KARBOWSKI Piotr <piotr.karbowski-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 2016-03-18 at 23:14 +0100, KARBOWSKI Piotr wrote:
> Hi,
> 
> On 03/18/2016 10:36 PM, Viacheslav Dubeyko wrote:
> > It needs to dive into state of the volume. You can use lscp and lssu
> > tools with the goal to retrieve segments and checkpoints state. But,
> > again, this path could provide opportunity for understanding the bug
> > essence and environment. I could see only one way for "recovering"
> > corrupted volume: (1) understand the current state of volume's segments;
> > (2) localize erroneous segment; (3) try to zero erroneous segment(s) by
> > means of dd utility; (4) try to mount again. But it's really dangerous
> > way, you could loose your data.
> 
> I could try, but lscp and lssu does not work with this filesystem since 
> crash. Only 'nilfs-tune -l' display anything.
> 
> # strace lssu /dev/loop/1 2>&1 | grep loop
> execve("/usr/bin/lssu", ["lssu", "/dev/loop/1"], [/* 61 vars */]) = 0
> readlink("/dev/loop", 0x7ffe6a073ac0, 4096) = -1 EINVAL (Invalid argument)
> readlink("/dev/loop/1", 0x7ffe6a073ac0, 4096) = -1 EINVAL (Invalid argument)
> readlink("/dev/loop", 0x7ffe6a073ac0, 4096) = -1 EINVAL (Invalid argument)
> readlink("/dev/loop/1", 0x7ffe6a073ac0, 4096) = -1 EINVAL (Invalid argument)
> write(2, "lssu: cannot open NILFS on /dev/"..., 66lssu: cannot open 
> NILFS on /dev/loop/1: No such file or directory
> 
> Does lscp and lssu needs actually mounted filesystem? It does run 
> readlink() and check /proc/mounts...
> 

Ahhh, I've forgot that you cannot mount your volume. Yes, you can use
lscp and lssu for mounted volume only. So, it needs to analyze raw
volume's content in such situation. No another way. Welcome to the real
world. Sorry..

If you have such issue after power outage then the most probable reason
of such issue is corruption of the last segment. Theoretically, NILFS2
has all necessary for recovering from such issue (because NILFS2 has
checkpoints for all metadata in previous logs). But current state of
NILFS2 code is unable to overcome such situation. Another possible
reason could be inconsistent state of superblock. NILFS2 has two
superblocks (in the beginning and in the end of the volume). So, it's
possible that one of the superblock (or both) has inconsistent state. It
means that some of superblock's field will contain some invalid state.
So, you need to elaborate vision what's wrong on your volume and to
modify the volume state manually.

Thanks,
Vyacheslav Dubeyko.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

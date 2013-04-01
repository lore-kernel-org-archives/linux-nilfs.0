From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Strange "flush" process bahaviour
Date: Mon, 01 Apr 2013 10:06:11 +0400
Message-ID: <1364796371.2202.16.camel@slavad-ubuntu>
References: <20121128205943.GZ4028@wloczykij>
	 <1354172459.2077.11.camel@slavad-ubuntu> <20130328120700.GK1672@wloczykij>
	 <E24177B1-2EF0-4274-BD13-4642E3663D08@dubeyko.com>
	 <20130329074249.GL1672@wloczykij> <1364544910.11128.9.camel@slavad-ubuntu>
	 <20130329103710.GM1672@wloczykij> <1364556557.11128.28.camel@slavad-ubuntu>
	 <20130329135722.GN1672@wloczykij>
	 <1D751B59-8E60-4D32-80CA-734BD25EE12C@dubeyko.com>
	 <20130331132609.GA1781@wloczykij>
Reply-To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:Reply-To:From:Subject:Message-ID; bh=uup9lxzn+6w+GgeFOnZ0iFDWFrmilePeD6f8rfpYgzg=;
	b=at3hup2Vo4BZzLLAt2VaxcyurEGQNbPjrCp27eOtf+s//oCi8AEzwdBATxzBO0foo1CYk95YHqHb52lofYfY5+33ilUtucW6QVsgmwX8fAevXE2dUZVuoXRWUIh2cjfa;
In-Reply-To: <20130331132609.GA1781@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, 2013-03-31 at 15:26 +0200, Piotr Szymaniak wrote:

[snip]
> 
> Hrm, maybe this is btrfs realated then? But I suppose I don't have any
> btrfs on the second machine with flush issues.
> 

If you detected issue with flush-8:0 kernel thread then it is a NILFS2
related issue, as I understand. Because flush-8:0 processes /dev/sda
drive and you have NILFS2 partition on /dev/sda3 (/dev/sda3 on / type
nilfs2 (rw,noatime,nodiratime,gcpid=16150)).

> I had a system freeze yesterday and right after reboot flush is back.
> So it looks like I can reproduce it (something makes the flush thing
> while booting. Maybe I can catch some debug info there?). Right now I'm
> going back to 3.4.x series kernel.
> 

The visible symptoms of the issue (flush kernel thread "abnormal"
activity) is not a reason of the issue. Such "abnormal" activity of
flush kernel thread takes place because in nilfs_mdt_write_page() and
nilfs_write_page() can be called with wbc->for_kupdate or
wbc->for_background flags. It is made simply
redirty_page_for_writepage() for such case.

The real issue hides in other NILFS2 subsystem. And only clear
understanding of file system operation that initiates such "abnormal"
activity of flush kernel thread can be a basis for further debugging and
investigation of the issue.

With the best regards,
Vyacheslav Dubeyko.

> 
> Piotr Szymaniak.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

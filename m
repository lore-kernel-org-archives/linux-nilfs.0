From: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] nilfs-utils: mkfs.nilfs2 should check presence of NILFS2
 volume on device
Date: Sun, 24 Mar 2013 11:03:11 -0500
Message-ID: <514F23BF.601@redhat.com>
References: <1364039122.16985.2.camel@slavad-ubuntu-12.04> <201303241309.19162.Martin@lichtvoll.de> <91A35B7F-A668-4B57-888F-7CE2A7D0ED86@dubeyko.com> (sfid-20130324_145707_596771_A57FD43C) <201303241543.23310.Martin@lichtvoll.de> <8C599058-8F00-4B0E-9BB0-D7F1DF34DC91@dubeyko.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8C599058-8F00-4B0E-9BB0-D7F1DF34DC91-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: Martin Steigerwald <Martin-3kZCPVa5dk2azgQtNeiOUg@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hendrik-j5CO6tLloWodnm+yROfE0A@public.gmane.org

On 3/24/13 11:08 AM, Vyacheslav Dubeyko wrote:
> Yes, using of libblkid is an excellent suggestion. As I see, it
> exists an example for mkfs utilities in libblkid library. So, I'll do
> it in the way that you suggest.

Yes, if you want to do this, it's pretty easy.  Here is the btrfs
commit:

http://git.kernel.org/cgit/linux/kernel/git/mason/btrfs-progs.git/commit/?id=2a2d8e1962e8b6cda7b0a7584f6d2fb95d442cb6

some people liked it, some did not like it at all, but in the end the option stayed in.

-Eric
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

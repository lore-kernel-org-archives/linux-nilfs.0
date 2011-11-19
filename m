From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Does nilfs2 checksum all data?
Date: Sun, 20 Nov 2011 00:10:58 +0900 (JST)
Message-ID: <20111120.001058.94864982.ryusuke@osrg.net>
References: <ja8d9m$n60$1@dough.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ja8d9m$n60$1@dough.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: bl4.929b-36pCxkIrkqeZuzBka8ofvg@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Sat, 19 Nov 2011 15:08:54 +0100, bl4 wrote:
> Hi,
> Does nilfs2 store checksums of all data and verify them when reading?

nilfs2 store checksums for all data.  However, at least the current
implementation does not verify it when reading.

Actually, the main purpose of the checksums is recovery after
unexpected reboot; it does not suit for per-file data verification
because the checksums are given per ``log''.


Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

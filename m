From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [ANNOUNCE] nilfs-utils 2.2.2 release
Date: Fri, 19 Sep 2014 02:51:46 +0900 (JST)
Message-ID: <20140919.025146.2174333538539183466.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:subject:from:mime-version:content-type
         :content-transfer-encoding;
        bh=AytshFKOns83VQqIEM4V0iDs1+ZdtTTegfqvPmD2SXo=;
        b=dGH91TYPNHjMlsOfJhCoCP8N+DPbCzESWKth2Il6ua9MqeG8cc6UUvdgUM/tyVA3hr
         JYkeSi0jrXf7eIGjQb47Sv2bx+dBogV4zC/nziHVoT7rMk2dG/kUYDuQi1YfMcD3wWvV
         vei4pxQ/PIbdHf1Yh67tiRcTJgIM3Bhyj7dc8qvOkQxNKpT5DPbHBmnIFGPRgZwid+WE
         6spoVNetYE+TUWO5SS8ni7yczuZEH7DzS9+bEKZ469NfAfQ+4NF9OgNarW9d4DKXAn53
         5/podt1ITa1o0QdPeH7bQDXuacxrmMML00ZxJLE025JTIO7ERL145KqmVkAB3gHiCv/S
         sx3g==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

nilfs-utils 2.2.2 was released on:

 http://nilfs.sourceforge.net/en/download.html

This release fixes an issue of mount.nilfs2 program which is causing
failure of cleanerd's invocation under systemd 216+.

Changes from nilfs-utils-2.2.1 are as follows:

Dan McGee (2):
      libmount: don't base GC startup on no-mtab context
      lscp: always show snapshots, even if marked minor

Ryusuke Konishi (3):
      lscp: show snapshots, even if marked minor (reverse mode)
      mount.nilfs2: invoke cleanerd even if no-mtab option is specified
      nilfs-utils: v2.2.2 release

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

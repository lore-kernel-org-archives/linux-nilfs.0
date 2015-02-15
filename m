From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [ANNOUNCE] nilfs-utils 2.2.3 release
Date: Mon, 16 Feb 2015 08:36:41 +0900 (JST)
Message-ID: <20150216.083641.1051906482591177089.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:subject:from:mime-version:content-type
         :content-transfer-encoding;
        bh=yERoEx/Y1ArFY9YEVw5cDjV4QtbBE2LykBmoO1lv0RI=;
        b=eB7fGagUWxSBbOg7TEqVSTR/SH5425WQL2a0imeCAJRGbz3QC7kevN5FJiEzfMtTlm
         46BNTi5InbEweqQyb2DHqM+bCyfq/nM4Ou63g+48F1rZ7jYdEkvyBOdBxdyTRgfClN+A
         FkGhvzlKg1GAzxRAYc2v5dbxiiI5o+u9BR/nQ8Tm051th7cmDheEOoRTZaPsK1FS+yRj
         N6astQoB8rD5/WMOrmJCykCo7ehJ83k1A8kev+n96t2cCewQCh3c4Jtq8qeiHMTPw+kZ
         1XDL/bCfbantPOJVIkPK9ACIqRgvt9hSHq4VttLwesr7rv2bCP9dEz7dEmitgu0REe6E
         73Ew==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

nilfs-utils 2.2.3 was released on:

 http://nilfs.sourceforge.net/en/download.html

This release fixes potential leak of nilfs library and an issue that
lscp command takes too long to output checkpoint list in the reverse
direction.

Changes from nilfs-utils-2.2.2 are as follows:

Ryusuke Konishi (5):
      lib/nilfs.c: fix potential leak at nilfs_open()
      nilfs-utils: get rid of my_free()
      nilfs-utils: get rid of null checks before calling free()
      lscp: accelerate backward checkpoint listing
      nilfs-utils: v2.2.3 release


Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

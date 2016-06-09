From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [PATCH 04/21] fs: Replace CURRENT_TIME with current_fs_time() for
 inode timestamps
Date: Thu, 9 Jun 2016 22:05:47 +0900
Message-ID: <CAKFNMomnVXMO49LDGsZ=UAxyD7fF88Aq29d-XR5Brqsn41+TYw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:from:date:message-id:subject:to:cc;
        bh=YI3DH4V8yJU9hvPQYv3RtWCiRb3QGwnPvTlO3vPT+uY=;
        b=wLTcTVZ01U0H9vmqkRaWhAgaNoGbrowbql0/7tIBztHaAKt85j78edkhZBeolnrqJo
         m03PMGLG8f+eWubtasAkNYSwgQRSkrWprFL3mgTGYgq0ei5J5irZCESfAKsWUDvUuswL
         y9Wv9Dq8jwWoOmwQJxXTI8njbZG8cDu4gKVEsjIYQ8CsEhByKoz+nEQhf1zbZSQwPUyS
         QeZ1U4g7+ZXN6f5CkXbr4nYuUy81L6Fx2T+xLJw3ZpkpvS3KU5/voHoX+hyGpPopsawp
         XsbftlL+oUZ/oGd87QLswgSskZcUMfsBnsXQ5rvIXt1ohGbEk+stduCSE0w7oKmUK2hl
         +rPQ==
Sender: owner-linux-mm@kvack.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, y2038@lists.linaro.org, Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, Joern Engel <joern@logfs.org>, Prasad Joshi <prasadjoshi.linux@gmail.com>, logfs@logfs.org, Andrew Morton <akpm@linux-foundation.org>, Julia Lawall <Julia.Lawall@lip6.fr>, David Howells <dhowells@redhat.com>, Firo Yang <firogm@gmail.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>, Chao Yu <chao2.yu@samsung.com>, linux-f2fs-devel@lists.sourceforge.net, Michal Hocko <mhocko@suse.com>, Konstantin Khlebnikov <koct9i@gmail.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, "J. Bruce Fields" <bfields@fields>

for nilfs2 bits:

Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Thanks,
Ryusuke Konishi

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

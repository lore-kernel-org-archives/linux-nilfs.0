From: Lukas Bulwahn <lukas.bulwahn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: References to non-existing configs in the NILFS2 FILESYSTEM
Date: Thu, 30 Dec 2021 13:59:46 +0100
Message-ID: <CAKXUXMxh=QK4C5OfLL1wSvoGFJZ8U+EhSr5dy9ddExtVhAdU-Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=KBYUy4F1EkXBdZcvrhlETrInDlhxQrDb/K+4x/wDGCY=;
        b=gqngpeMpoYQ4piP+SbH4Dv7nTr4f1JG+97AEcCC6UgrmpbD5M2uAru8zIOYEYF8qjI
         9akjvzoEZtHLnIBM/E5hiV/SsSNlZ5lrgx/XI6+cd7Erc2g75qR79hHb6KmoK6BxTRgu
         pgoICgylsPk4Mum8a8HeGGEUY6Q3+/uB7n1IUsM+KuSXZStnD32lCEMIveNtM+ncg0k8
         ooNFx24cUFaXXKGXhDCLKhx3qRfbXSrA3LVtiXJ1Q0O6cgrwjO4yX+/c/b4wNtEvvNSe
         XCdQyajvMpgGmqjAdM0vlFQ5Qqgy7/4xk+cpj1/b2b6wzTRpHUZcWwrmmr7VpffZewqP
         0pBw==
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Dear Ryusuke Konishi-san,


The script ./scripts/checkkconfigsymbols.py identifies references to
non-existing configs in the NILFS2 FILESYSTEM:

NILFS_POSIX_ACL
Referencing files: fs/nilfs2/nilfs.h

NILFS_XATTR
Referencing files: fs/nilfs2/nilfs.h, fs/nilfs2/super.c

I assume this filesystem support is simply not yet developed to
support those two configs fully, and these code blocks are just some
first steps in that direction, but are currently just intended to be
dead code in the repository. If you do not see this support to be
added in the future, you could also just delete these ifdef blocks and
these references to non-existing configs.

This is just to share this information with you; there is no need for
further action.


Best regards,

Lukas

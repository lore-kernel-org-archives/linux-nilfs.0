From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [ANNOUNCE] nilfs2-kmod for CentOS 7
Date: Wed, 09 Jul 2014 05:44:00 +0900 (JST)
Message-ID: <20140709.054400.1530368610889981639.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:subject:from:mime-version:content-type
         :content-transfer-encoding;
        bh=ysh4b1HMpY+KiNnhJjeg/bmNRqGx1TFbehpHBH5L9Do=;
        b=sEsbMssIUigqR7r1wnCAQu8YjYKCL/joEnsGi5+meoZ/ngy41EpdESdVXBWpUbuPL/
         dsrf2bXaPCCxeGgV8U8jXr6ZhegGF2Tjff2eV/Ni8pR5kLQ6Hcua5Z6HjVSLfhA3lpm0
         Ovcd57oVKoO8OFpQZY99dpM7xSObMuQO4DbeW2K69su/q0LJBITp0TvFMn/WQ3VnYBp9
         ia1SNn+3Nf+mbQ5NMUGs4q27ZAntGbH95Ohn8UTjcj3O2UaKr2BeJ15jJNuqQ2zcX1NL
         OeABimTma2kOg/DVGmtOhLr9EpZn6d6u6dFOKvYp+N2c744WV16c/Z/5C+KJOpvQlJd9
         wSzg==
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi lists,

nilfs2 standalone kernel module for CentOS 7.0 is now available.

Source files of the module is obtainable with "git" command:

 $ git clone git://github.com/nilfs-dev/nilfs2-kmod-centos7.git

For details on installation, please see README file in the package.

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

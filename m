From: Yangtao Li <frank.li@vivo.com>
Subject: Re: [PATCH v3 01/10] kobject: introduce kobject_del_and_put()
Date: Tue,  4 Apr 2023 21:30:37 +0800
Message-ID: <20230404133037.66927-1-frank.li@vivo.com>
References: <ZBvgpBzEuFuyOD/c@ovpn-8-16.pek2.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o9gRzrJioyaXd7x2Nt5LwWdJliejgTOkFIZ6yPNQB8M=;
 b=i+boe1mrB9bH8RQ0WUqR4nlBCrj/YrH90RKuJZq77MVzmLBSKbWu08HJbppLWYB6gKXGPViFAJx5O4VU2dtpo9m5vwIURruNRIehpcgtlA5Iuz6O2R6fIqxkQa3iNaUZNXQ5bzvVPKIVvjR3wd2bA+32D79iBlYrjHYSKxWCni3Vc8gEoPZqw3M6LtPtXd2oM1ir0Me7v8KWk9xenS+7Qxlbeg+RaduepbeuB9apDuNv2tkwNIYDXDi+54OxQgxi0kcfU5Buzb1n/dqsc+94K4KSVzlILDL7iz+PhG6lFxoEV84WYiX5/TmAr5DC126aBad+T/S6Rf221yr0+G7vIg==
In-Reply-To: <ZBvgpBzEuFuyOD/c@ovpn-8-16.pek2.redhat.com>
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ming.lei@redhat.com
Cc: anna@kernel.org, chao@kernel.org, clm@fb.com, damien.lemoal@opensource.wdc.com, djwong@kernel.org, dsterba@suse.com, frank.li@vivo.com, gregkh@linuxfoundation.org, huyue2@coolpad.com, jaegeuk@kernel.org, jefflexu@linux.alibaba.com, jlbec@evilplan.org, josef@toxicpanda.com, joseph.qi@linux.alibaba.com, jth@kernel.org, konishi.ryusuke@gmail.com, linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-xfs@vger.kernel.org, mark@fasheh.com, naohiro.aota@wdc.com, ocfs2-devel@oss.oracle.com, rafael@kernel.org, richard@nod.at, trond.myklebust@hammerspace.com, xiang@kernel.org

> kobject_put() actually covers kobject removal automatically, which is
> single stage removal. So if you see the two called together, it is
> safe to kill kobject_del() directly.

If the reference count is not abnormal, kobject_put() does contain
what kobject_del() does.

Thx,
Yangtao

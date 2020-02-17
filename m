From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 00/44] Manually convert filesystem FS documents to ReST
Date: Mon, 17 Feb 2020 17:11:46 +0100
Message-ID: <cover.1581955849.git.mchehab+huawei@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=m.gmane-mx.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.infradead.org; s=bombadil.20170209; h=Sender:
	Content-Transfer-Encoding:Content-Type:Cc:List-Subscribe:List-Help:List-Post:
	List-Archive:List-Unsubscribe:List-Id:MIME-Version:Message-Id:Date:Subject:To
	:From:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:
	List-Owner; bh=H95DvEZj2JwS3zF0yBt+U0rKTnNy72b22uvUUYEgLkU=; b=Wt2+q6ybkvwNkR
	eUwUTkoRblliLFR6AlJTT05mNQ1E5B+CjMnlBnPRMLpX2idjbXxa81ITqSl2U40iEtDbIBjmDqwD9
	mi2/Ooj6e/b8nOQ/7L0PdmUxfn20u9k40uzMlulhCU7PNMRKpfzekCjamLfdjoFsmmL5CXZXr0IZI
	Uusjeea+3ND3gn8CYSLmX5tWnc6v2w85kafmq4FmwSBzrQ41Es0lY8DuJiVROCflbyvrPsbseCjit
	GlmTPrXTqCbYnKHjF+myHF5mL7rBa60yh3cGLGXmPbgd8IWE2FVQVNzo9qNXMG3huaabsHDE8blfI
	lyfxYyuLXneslSkOSzPw==;
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=m.gmane-mx.org@lists.infradead.org
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Latchesar Ionkov <lucho@ionkov.net>, Martin Brandenburg <martin@omnibond.com>, Jan Kara <jack@suse.cz>, Dominique Martinet <asmadeus@codewreck.org>, Amir Goldstein <amir73il@gmail.com>, Bob Copeland <me@bobcopeland.com>, David Howells <dhowells@redhat.com>, Joseph Qi <joseph.qi@linux.alibaba.com>, linux-mtd@lists.infradead.org, Tyler Hicks <code@tyhicks.com>, linux-afs@lists.infradead.org, Mike Marshall <hubcap@omnibond.com>, Naohiro Aota <naohiro.aota@wdc.com>, Christoph Hellwig <hch@infradead.org>, linux-nilfs@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>, Sage Weil <sage@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Mauro Carvalho Chehab <mchehab+huawei@kernel.org>, Richard Weinberger <richard@nod.at>, Mark Fasheh <mark@fasheh.com>, Chris Mason <clm@fb.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, cluster-devel@redhat.com, v9fs-developer@lists.sourc

There are lots of plain text documents under Documentation/filesystems.

Manually convert several of those to ReST and add them to the index file.

Mauro Carvalho Chehab (44):
  docs: filesystems: convert 9p.txt to ReST
  docs: filesystems: convert adfs.txt to ReST
  docs: filesystems: convert affs.txt to ReST
  docs: filesystems: convert afs.txt to ReST
  docs: filesystems: convert autofs-mount-control.txt to ReST
  docs: filesystems: convert befs.txt to ReST
  docs: filesystems: convert bfs.txt to ReST
  docs: filesystems: convert btrfs.txt to ReST
  docs: filesystems: convert ceph.txt to ReST
  docs: filesystems: convert cramfs.txt to ReST
  docs: filesystems: convert debugfs.txt to ReST
  docs: filesystems: convert dlmfs.txt to ReST
  docs: filesystems: convert ecryptfs.txt to ReST
  docs: filesystems: convert efivarfs.txt to ReST
  docs: filesystems: convert erofs.txt to ReST
  docs: filesystems: convert ext2.txt to ReST
  docs: filesystems: convert ext3.txt to ReST
  docs: filesystems: convert f2fs.txt to ReST
  docs: filesystems: convert gfs2.txt to ReST
  docs: filesystems: convert gfs2-uevents.txt to ReST
  docs: filesystems: convert hfsplus.txt to ReST
  docs: filesystems: convert hfs.txt to ReST
  docs: filesystems: convert hpfs.txt to ReST
  docs: filesystems: convert inotify.txt to ReST
  docs: filesystems: convert isofs.txt to ReST
  docs: filesystems: convert nilfs2.txt to ReST
  docs: filesystems: convert ntfs.txt to ReST
  docs: filesystems: convert ocfs2-online-filecheck.txt to ReST
  docs: filesystems: convert ocfs2.txt to ReST
  docs: filesystems: convert omfs.txt to ReST
  docs: filesystems: convert orangefs.txt to ReST
  docs: filesystems: convert proc.txt to ReST
  docs: filesystems: convert qnx6.txt to ReST
  docs: filesystems: convert ramfs-rootfs-initramfs.txt to ReST
  docs: filesystems: convert relay.txt to ReST
  docs: filesystems: convert romfs.txt to ReST
  docs: filesystems: convert squashfs.txt to ReST
  docs: filesystems: convert sysfs.txt to ReST
  docs: filesystems: convert sysv-fs.txt to ReST
  docs: filesystems: convert tmpfs.txt to ReST
  docs: filesystems: convert ubifs-authentication.rst.txt to ReST
  docs: filesystems: convert ubifs.txt to ReST
  docs: filesystems: convert udf.txt to ReST
  docs: filesystems: convert zonefs.txt to ReST

 Documentation/filesystems/{9p.txt => 9p.rst}  |  114 +-
 .../filesystems/{adfs.txt => adfs.rst}        |   29 +-
 .../filesystems/{affs.txt => affs.rst}        |   62 +-
 .../filesystems/{afs.txt => afs.rst}          |   73 +-
 ...t-control.txt => autofs-mount-control.rst} |  102 +-
 .../filesystems/{befs.txt => befs.rst}        |   59 +-
 .../filesystems/{bfs.txt => bfs.rst}          |   37 +-
 .../filesystems/{btrfs.txt => btrfs.rst}      |    3 +
 .../filesystems/{ceph.txt => ceph.rst}        |   26 +-
 .../filesystems/{cramfs.txt => cramfs.rst}    |   19 +-
 .../filesystems/{debugfs.txt => debugfs.rst}  |   54 +-
 .../filesystems/{dlmfs.txt => dlmfs.rst}      |   28 +-
 .../{ecryptfs.txt => ecryptfs.rst}            |   44 +-
 .../{efivarfs.txt => efivarfs.rst}            |    5 +-
 .../filesystems/{erofs.txt => erofs.rst}      |  175 +-
 .../filesystems/{ext2.txt => ext2.rst}        |   41 +-
 .../filesystems/{ext3.txt => ext3.rst}        |    2 +
 .../filesystems/{f2fs.txt => f2fs.rst}        |  252 +--
 .../{gfs2-uevents.txt => gfs2-uevents.rst}    |   20 +-
 .../filesystems/{gfs2.txt => gfs2.rst}        |   20 +-
 .../filesystems/{hfs.txt => hfs.rst}          |   23 +-
 .../filesystems/{hfsplus.txt => hfsplus.rst}  |    2 +
 .../filesystems/{hpfs.txt => hpfs.rst}        |  239 ++-
 Documentation/filesystems/index.rst           |   46 +-
 .../filesystems/{inotify.txt => inotify.rst}  |   33 +-
 Documentation/filesystems/isofs.rst           |   64 +
 Documentation/filesystems/isofs.txt           |   48 -
 .../filesystems/{nilfs2.txt => nilfs2.rst}    |   40 +-
 .../filesystems/{ntfs.txt => ntfs.rst}        |  143 +-
 ...lecheck.txt => ocfs2-online-filecheck.rst} |   45 +-
 .../filesystems/{ocfs2.txt => ocfs2.rst}      |   31 +-
 Documentation/filesystems/omfs.rst            |  112 ++
 Documentation/filesystems/omfs.txt            |  106 --
 .../{orangefs.txt => orangefs.rst}            |  187 +-
 .../filesystems/{proc.txt => proc.rst}        | 1498 +++++++++--------
 .../filesystems/{qnx6.txt => qnx6.rst}        |   22 +
 ...itramfs.txt => ramfs-rootfs-initramfs.rst} |   54 +-
 .../filesystems/{relay.txt => relay.rst}      |  129 +-
 .../filesystems/{romfs.txt => romfs.rst}      |   42 +-
 .../{squashfs.txt => squashfs.rst}            |   60 +-
 .../filesystems/{sysfs.txt => sysfs.rst}      |  324 ++--
 .../filesystems/{sysv-fs.txt => sysv-fs.rst}  |  155 +-
 .../filesystems/{tmpfs.txt => tmpfs.rst}      |   44 +-
 .../filesystems/ubifs-authentication.rst      |   10 +-
 .../filesystems/{ubifs.txt => ubifs.rst}      |   25 +-
 .../filesystems/{udf.txt => udf.rst}          |   21 +-
 .../filesystems/{zonefs.txt => zonefs.rst}    |  106 +-
 47 files changed, 2739 insertions(+), 2035 deletions(-)
 rename Documentation/filesystems/{9p.txt => 9p.rst} (63%)
 rename Documentation/filesystems/{adfs.txt => adfs.rst} (85%)
 rename Documentation/filesystems/{affs.txt => affs.rst} (86%)
 rename Documentation/filesystems/{afs.txt => afs.rst} (90%)
 rename Documentation/filesystems/{autofs-mount-control.txt => autofs-mount-control.rst} (89%)
 rename Documentation/filesystems/{befs.txt => befs.rst} (83%)
 rename Documentation/filesystems/{bfs.txt => bfs.rst} (71%)
 rename Documentation/filesystems/{btrfs.txt => btrfs.rst} (96%)
 rename Documentation/filesystems/{ceph.txt => ceph.rst} (91%)
 rename Documentation/filesystems/{cramfs.txt => cramfs.rst} (88%)
 rename Documentation/filesystems/{debugfs.txt => debugfs.rst} (91%)
 rename Documentation/filesystems/{dlmfs.txt => dlmfs.rst} (86%)
 rename Documentation/filesystems/{ecryptfs.txt => ecryptfs.rst} (70%)
 rename Documentation/filesystems/{efivarfs.txt => efivarfs.rst} (85%)
 rename Documentation/filesystems/{erofs.txt => erofs.rst} (54%)
 rename Documentation/filesystems/{ext2.txt => ext2.rst} (91%)
 rename Documentation/filesystems/{ext3.txt => ext3.rst} (88%)
 rename Documentation/filesystems/{f2fs.txt => f2fs.rst} (84%)
 rename Documentation/filesystems/{gfs2-uevents.txt => gfs2-uevents.rst} (94%)
 rename Documentation/filesystems/{gfs2.txt => gfs2.rst} (76%)
 rename Documentation/filesystems/{hfs.txt => hfs.rst} (80%)
 rename Documentation/filesystems/{hfsplus.txt => hfsplus.rst} (95%)
 rename Documentation/filesystems/{hpfs.txt => hpfs.rst} (66%)
 rename Documentation/filesystems/{inotify.txt => inotify.rst} (83%)
 create mode 100644 Documentation/filesystems/isofs.rst
 delete mode 100644 Documentation/filesystems/isofs.txt
 rename Documentation/filesystems/{nilfs2.txt => nilfs2.rst} (89%)
 rename Documentation/filesystems/{ntfs.txt => ntfs.rst} (85%)
 rename Documentation/filesystems/{ocfs2-online-filecheck.txt => ocfs2-online-filecheck.rst} (77%)
 rename Documentation/filesystems/{ocfs2.txt => ocfs2.rst} (88%)
 create mode 100644 Documentation/filesystems/omfs.rst
 delete mode 100644 Documentation/filesystems/omfs.txt
 rename Documentation/filesystems/{orangefs.txt => orangefs.rst} (83%)
 rename Documentation/filesystems/{proc.txt => proc.rst} (65%)
 rename Documentation/filesystems/{qnx6.txt => qnx6.rst} (98%)
 rename Documentation/filesystems/{ramfs-rootfs-initramfs.txt => ramfs-rootfs-initramfs.rst} (91%)
 rename Documentation/filesystems/{relay.txt => relay.rst} (91%)
 rename Documentation/filesystems/{romfs.txt => romfs.rst} (86%)
 rename Documentation/filesystems/{squashfs.txt => squashfs.rst} (91%)
 rename Documentation/filesystems/{sysfs.txt => sysfs.rst} (56%)
 rename Documentation/filesystems/{sysv-fs.txt => sysv-fs.rst} (73%)
 rename Documentation/filesystems/{tmpfs.txt => tmpfs.rst} (86%)
 rename Documentation/filesystems/{ubifs.txt => ubifs.rst} (91%)
 rename Documentation/filesystems/{udf.txt => udf.rst} (83%)
 rename Documentation/filesystems/{zonefs.txt => zonefs.rst} (90%)

-- 
2.24.1



______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/

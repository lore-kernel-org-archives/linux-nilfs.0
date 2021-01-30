From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 04/17] block: split bio_kmalloc from
	bio_alloc_bioset
Date: Sat, 30 Jan 2021 03:56:46 +0000
Message-ID: <20210130035646.GH308988@casper.infradead.org>
References: <20210126145247.1964410-1-hch@lst.de>
	<20210126145247.1964410-5-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209;
	h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=DenP85I1Njjb0sm/Pv5awH6u78JiwmjeMN74Dl7XDmA=;
	b=H8SDl3brId4iyEQMOwW4BfEUQ2
	Xy9mZcqFmFvcWvR6dxLgQ3QUwF+RwC9GNnBM28jr+2J7JQ5Bm8pWtzkJy9Bu5683unOHOgLMv+gFM
	jYIfOM6Ao2NNEjEzqoWU83ro0i2k1QtT++2jpOr8mpPL1+MxGJTvy2GRgyUg+z6xssmGMSAnWY2zd
	lqlVaZEtkQfNNrYTdAkx5Dh4tKL60XSKbWMPsTXg7ShS8Q1MALyQ1L4XvADIPpEa3DQT7A35auYCK
	RYKeUzMDMR7ROqaOWCMHMSpzECR3dkUR8mtXMmO0lgMzXZcgza2tXYiFwaZvQ9UvVr3UoISIOLjsY
	syMo01WQ==;
Content-Disposition: inline
In-Reply-To: <20210126145247.1964410-5-hch-jcswGhMUV9g@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, Naohiro Aota <naohiro.aota-Sjgp3cTcYWE@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chao Yu <chao-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Coly Li <colyli-l3A5Bk7waGM@public.gmane.org>, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>, Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ryusuke Konishi <konishi.ryusuke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Damien Le Moal <damien.lemoal-Sjgp3cTcYWE@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Philipp Reisner <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jan 26, 2021 at 03:52:34PM +0100, Christoph Hellwig wrote:
> bio_kmalloc shares almost no logic with the bio_set based fast path
> in bio_alloc_bioset.  Split it into an entirely separate implementation.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>  block/bio.c         | 167 ++++++++++++++++++++++----------------------
>  include/linux/bio.h |   6 +-
>  2 files changed, 86 insertions(+), 87 deletions(-)

This patch causes current linux-next to OOM for me when running xfstests
after about ten minutes.  Haven't looked into why yet, this is just the
results of a git bisect.

The qemu command line is:

qemu-system-x86_64 -nodefaults -nographic -cpu host -machine accel=kvm,nvdimm -m 2G,slots=8,maxmem=1T -smp 6 -kernel /home/willy/kernel/folio/.build_test_kernel-x86_64/kpgk/vmlinuz -append console=hvc0 root=/dev/sda rw log_buf_len=8M ktest.dir=/home/willy/kernel/ktest ktest.env=/tmp/build-test-kernel-nJO6QgxOmo/env quiet systemd.show_status=0 systemd.log-target=journal crashkernel=128M no_console_suspend -device virtio-serial -chardev stdio,id=console -device virtconsole,chardev=console -serial unix:/tmp/build-test-kernel-nJO6QgxOmo/vm-kgdb,server,nowait -monitor unix:/tmp/build-test-kernel-nJO6QgxOmo/vm-mon,server,nowait -gdb unix:/tmp/build-test-kernel-nJO6QgxOmo/vm-gdb,server,nowait -device virtio-rng-pci -virtfs local,path=/,mount_tag=host,security_model=none -device virtio-scsi-pci,id
 =hba -nic user,model=virtio,hostfwd=tcp:127.0.0.1:24674-:22 -drive if=none,format=raw,id=disk0,file=/var/lib/ktest/root.amd64,snapshot=on -device scsi-hd,bus=hba.0,drive=disk0 -drive if=none
 ,format=raw,id=disk1,file=/tmp/build-test-kernel-nJO6QgxOmo/dev-1,cache=unsafe -device scsi-hd,bus=hba.0,drive=disk1 -drive if=none,format=raw,id=disk2,file=/tmp/build-test-kernel-nJO6QgxOmo/dev-2,cache=unsafe -device scsi-hd,bus=hba.0,drive=disk2 -drive if=none,format=raw,id=disk3,file=/tmp/build-test-kernel-nJO6QgxOmo/dev-3,cache=unsafe -device scsi-hd,bus=hba.0,drive=disk3

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7932F6572;
	Thu,  4 Sep 2025 23:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757028598; cv=none; b=gxmUCnKb9xnESPJHtqL3Fxupe2vHkrHlCwwEBLth4+VrSA03hUBrC/SeMx7tBzXie8MmwexgMFpiJbZglx27OsDds/HXhcefGvooi7ziRii/49ocnEfl4Eg/G78NDxkRVYgAeVo037l5k6fDYxwyajbduRqI45DWVFYF4SooF/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757028598; c=relaxed/simple;
	bh=ndLknwe5xfqy6CNX1AX+c1fpxu8gTtl1MGnMPCXlSJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UpkIFhMbwc9caSjTq3oKsxSrUbJG0sd2qypljnq63iB/uZVFIeD78+frraMmyzD+bg2eCtwOktZ6r0A1tCYlfjE1AzZMbyuBz8Na8doZl5OzwSsDmCDszwyV9qLk1kRlAWn/Z9MNxvKZo+fKk6ZlPPDQh3ZL9IiGScfIi0EVE7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MyPB7c2g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MyPB7c2g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A40C4CEF0;
	Thu,  4 Sep 2025 23:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757028598;
	bh=ndLknwe5xfqy6CNX1AX+c1fpxu8gTtl1MGnMPCXlSJQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MyPB7c2gxpp7+LIyEAU++uoWfgf4M+akKI5eL7opmyOX+CRcXPDLkyIYxd897Wn7h
	 klQzf+nQ27zjURskordTIIlCvt3KxXLby9lQ5RkwSNVK25n7L7AWeMzP75N7Fm3slU
	 W+t9FXkn/ATB73slc4lPVNjXydJ0ATULMk0SifkmtkSN9HP8ZLr6bqGKWV/sMgK8ly
	 CIV6POA5V/VK6VOa1seTqZHpNkBy/GAN10RyCCEMxa0rNnYdOnfH3BDGxvZpLy5oe8
	 RDlDYVM0s3wgMxeCR2NHTSkvlFUCrDbUC1n+G17xc7VNzeMg+Q75xn1N49lMiOn2kY
	 PnaL4+1faOy4g==
Date: Thu, 4 Sep 2025 16:29:52 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: kernel test robot <oliver.sang@intel.com>,
	Borislav Petkov <bp@kernel.org>, oe-lkp@lists.linux.dev,
	lkp@intel.com, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, X86 ML <x86@kernel.org>,
	"Chang S. Bae" <chang.seok.bae@intel.com>,
	Sohil Mehta <sohil.mehta@intel.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	linux-nilfs@vger.kernel.org
Subject: Re: [PATCH -v1 1/2] x86/microcode: Add microcode= cmdline parsing
Message-ID: <20250904232952.GA875818@ax162>
References: <20250820135043.19048-2-bp@kernel.org>
 <202509021646.bc78d9ef-lkp@intel.com>
 <20250904113752.GDaLl6ELJRd3LZYBQl@fat_crate.local>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904113752.GDaLl6ELJRd3LZYBQl@fat_crate.local>

Hi Boris and the Intel folks,

+ Ryusuke and linux-nilfs

On Thu, Sep 04, 2025 at 01:37:52PM +0200, Borislav Petkov wrote:
> On Tue, Sep 02, 2025 at 04:45:12PM +0800, kernel test robot wrote:
> > 
> > 
> > Hello,
> > 
> > 
> > this could be a noise, we didn't see the relation between the patch with the
> > issue we observed. however, we rebuild the kernels for both this commit and
> > parent 3 times.
> > (
> > our bot chose 894af4a1cde61c as the parent as below
> > * 19f370d45aceea x86/microcode: Add microcode= cmdline parsing
> > * 894af4a1cde61c (tip/x86/core, peterz-queue/x86/core) objtool: Validate kCFI calls
> > )
> > 
> > and for each rerun of both this commit and parent, we run more times, but the
> > issue is still quite persistent while parent keeps clean:
> > 
> > =========================================================================================
> > tbox_group/testcase/rootfs/kconfig/compiler/runtime/group/nr_groups:
> >   vm-snb/trinity/debian-11.1-i386-20220923.cgz/x86_64-randconfig-006-20250826/clang-20/300s/group-01/5
> > 
> > 894af4a1cde61c34 19f370d45aceea5ab4c52e3afa0
> > ---------------- ---------------------------
> >        fail:runs  %reproduction    fail:runs
> >            |             |             |
> >            :200         74%         149:200   last_state.is_incomplete_run
> >            :200         74%         147:200   last_state.running
> >            :200         75%         150:200   dmesg.CFI_failure_at_kobj_attr_show
> >            :200         75%         150:200   dmesg.Kernel_panic-not_syncing:Fatal_exception
> >            :200         75%         150:200   dmesg.Oops:invalid_opcode:#[##]KASAN
> >            :200         75%         150:200   dmesg.RIP:kobj_attr_show
> >            :200         75%         150:200   dmesg.boot_failures
> > 
> > so we just follow our report rule to still report this results FYI.
> > 
> > if it's really irrelevant, sorry maybe our env issues (though we still cannot
> > figure out for now). and if you can help us to figure out the potential problem
> > from our dmesg in below link, it will be very apprecidated!
> 
> Yeah, I don't know what you did here but building with that .config, I can't
> even boot that kernel in a VM because doing:
> 
> qemu-... -kernel bzImage ...
> 
> sends me into grub and asks me to select the default kernel.
> 
> And my qemu script boots arbitrary kernels just fine.

Does your QEMU boot via UEFI? This configuration has

  # CONFIG_EFI is not set

so if I try to boot QEMU via OVMF, I get:

  BdsDxe: failed to load Boot0002 "UEFI Non-Block Boot Device" from VenMedia(1428F772-B64A-441E-B8C3-9EBDD7F893C7): Not Found
  BdsDxe: No bootable option or device was found.
  BdsDxe: Press any key to enter the Boot Manager Menu.

Turning on CONFIG_EFI and CONFIG_EFI_STUB is enough for me to boot this
configuration.

> Also, I used clang-20 from here:
> 
> https://mirrors.edge.kernel.org/pub/tools/llvm/
> 
> and version 20.1.8 took something like ~10(!) minutes to link vmlinux with
> that config. Just FYI for Nathan, maybe something's weird there.

Looks like this configuration has

  CONFIG_LTO_CLANG_FULL=y

so that's not too surprising :) turning that off or making it

  CONFIG_LTO_CLANG_THIN=y

should be much quicker.

> > below is full report.
> 
> Leaving it in.

As for the actual report...

I ran 200 boots using our simple Buildroot initrd and QEMU wrapper
script [1] and saw no issues, however...

[1]: https://github.com/ClangBuiltLinux/boot-utils

> > kernel test robot noticed "CFI_failure_at_kobj_attr_show" on:
> > 
> > commit: 19f370d45aceea5ab4c52e3afa00226fb99c3fc8 ("[PATCH -v1 1/2] x86/microcode: Add microcode= cmdline parsing")
> > url: https://github.com/intel-lab-lkp/linux/commits/Borislav-Petkov/x86-microcode-Add-microcode-cmdline-parsing/20250820-215624
> > base: https://git.kernel.org/cgit/linux/kernel/git/tip/tip.git 894af4a1cde61c3401f237184fb770f72ff12df8
> > patch link: https://lore.kernel.org/all/20250820135043.19048-2-bp@kernel.org/
> > patch subject: [PATCH -v1 1/2] x86/microcode: Add microcode= cmdline parsing
> > 
> > in testcase: trinity
> > version: trinity-i386-abe9de86-1_20230429
> > with following parameters:
> > 
> > 	runtime: 300s
> > 	group: group-01
> > 	nr_groups: 5
> > 
> > 
> > 
> > config: x86_64-randconfig-006-20250826
> > compiler: clang-20
> > test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G
> > 
> > (please refer to attached dmesg/kmsg for entire log/backtrace)
> > 
> > 
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <oliver.sang@intel.com>
> > | Closes: https://lore.kernel.org/oe-lkp/202509021646.bc78d9ef-lkp@intel.com
> > 
> > 
> > The kernel config and materials to reproduce are available at:
> > https://download.01.org/0day-ci/archive/20250902/202509021646.bc78d9ef-lkp@intel.com
> > 
> > 
> > [  453.382281][ T7761] CFI failure at kobj_attr_show+0x59/0x80 (target: nilfs_feature_revision_show+0x0/0x30; expected type: 0x1b8aae92)

I am surprised that this was not reproducible at 894af4a1cde61c34 for
the Intel folks because it does for me assuming I actually try to read
that file (maybe trinity was not hitting it on the older revision?):

  $ cat /sys/fs/nilfs2/features/revision
  [    6.975426][  T150] CFI failure at kobj_attr_show+0x59/0x80 (target: nilfs_feature_revision_show+0x0/0x30; expected type: 0xed60cafc)
  [    6.976822][  T150] Oops: invalid opcode: 0000 [#1] KASAN
  [    6.977407][  T150] CPU: 0 UID: 0 PID: 150 Comm: cat Not tainted 6.17.0-rc2-00016-g894af4a1cde6 #1 NONE
  [    6.978432][  T150] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
  [    6.979752][  T150] RIP: 0010:kobj_attr_show+0x59/0x80
  [    6.980321][  T150] Code: 08 00 74 08 4c 89 e7 e8 05 6b d6 fb 4d 8b 1c 24 4d 85 db 74 1f 4c 89 ff 4c 89 f6 48 89 da 41 ba 04 35 9f 12 45 03 53 f1 74 02 <0f> 0b 41 ff d3 0f 1f 00 eb 07 48 c7 c0 fb ff ff ff 5b 41 5c 41 5e
  [    6.982456][  T150] RSP: 0018:ffa0000000e17b28 EFLAGS: 00010216
  [    6.983163][  T150] RAX: 1ffffffff3753765 RBX: ff11000109eca000 RCX: dffffc0000000000
  [    6.984012][  T150] RDX: ff11000109eca000 RSI: ffffffff9ba9bb00 RDI: ff11000100b4f250
  [    6.984900][  T150] RBP: ffa0000000e17b48 R08: ff11000109ecafff R09: ff11000109eca000
  [    6.985830][  T150] R10: 000000007b3f6fc3 R11: ffffffff9541ea80 R12: ffffffff9ba9bb28
  [    6.986658][  T150] R13: 1fe2200020fdfe80 R14: ffffffff9ba9bb00 R15: ff11000100b4f250
  [    6.987542][  T150] FS:  00007f4818d2b740(0000) GS:0000000000000000(0000) knlGS:0000000000000000
  [    6.988508][  T150] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [    6.989241][  T150] CR2: 00007f481899a000 CR3: 0000000109f3b002 CR4: 0000000000371eb0
  [    6.990120][  T150] Call Trace:
  [    6.990498][  T150]  <TASK>
  [    6.990867][  T150]  sysfs_kf_seq_show+0x2a6/0x390
  [    6.991410][  T150]  ? __cfi_kobj_attr_show+0x10/0x10
  [    6.992015][  T150]  kernfs_seq_show+0x104/0x15b
  [    6.992542][  T150]  seq_read_iter+0x580/0xe2b
  [    6.993076][  T150]  kernfs_fop_read_iter+0x137/0x470
  [    6.993650][  T150]  new_sync_read+0x27e/0x365
  [    6.994185][  T150]  vfs_read+0x1e8/0x46b
  [    6.994650][  T150]  ksys_read+0xc2/0x170
  [    6.995129][  T150]  __x64_sys_read+0x7f/0x90
  [    6.995631][  T150]  ? entry_SYSCALL_64_after_hwframe+0x6b/0x73
  [    6.996299][  T150]  x64_sys_call+0x2589/0x2cdb
  [    6.996843][  T150]  do_syscall_64+0x89/0xfa0
  [    6.997343][  T150]  ? irqentry_exit+0x33/0x70
  [    6.997882][  T150]  ? exc_page_fault+0x96/0xe0
  [    6.998400][  T150]  entry_SYSCALL_64_after_hwframe+0x6b/0x73
  [    6.999068][  T150] RIP: 0033:0x7f4818dc11ce
  [    6.999564][  T150] Code: 4d 89 d8 e8 64 be 00 00 4c 8b 5d f8 41 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 11 c9 c3 0f 1f 80 00 00 00 00 48 8b 45 10 0f 05 <c9> c3 83 e2 39 83 fa 08 75 e7 e8 13 ff ff ff 0f 1f 00 f3 0f 1e fa
  [    7.001627][  T150] RSP: 002b:00007ffc2d325600 EFLAGS: 00000202 ORIG_RAX: 0000000000000000
  [    7.002558][  T150] RAX: ffffffffffffffda RBX: 0000000000040000 RCX: 00007f4818dc11ce
  [    7.003443][  T150] RDX: 0000000000040000 RSI: 00007f481899b000 RDI: 0000000000000003
  [    7.004363][  T150] RBP: 00007ffc2d325610 R08: 0000000000000000 R09: 0000000000000000
  [    7.005260][  T150] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000040000
  [    7.006143][  T150] R13: 00007f481899b000 R14: 0000000000000003 R15: 0000000000000000
  [    7.007027][  T150]  </TASK>
  [    7.007411][  T150] Modules linked in:
  [    7.007994][  T150] ---[ end trace 0000000000000000 ]---
  [    7.008711][  T150] RIP: 0010:kobj_attr_show+0x59/0x80
  [    7.009430][  T150] Code: 08 00 74 08 4c 89 e7 e8 05 6b d6 fb 4d 8b 1c 24 4d 85 db 74 1f 4c 89 ff 4c 89 f6 48 89 da 41 ba 04 35 9f 12 45 03 53 f1 74 02 <0f> 0b 41 ff d3 0f 1f 00 eb 07 48 c7 c0 fb ff ff ff 5b 41 5c 41 5e
  [    7.011712][  T150] RSP: 0018:ffa0000000e17b28 EFLAGS: 00010216
  [    7.012369][  T150] RAX: 1ffffffff3753765 RBX: ff11000109eca000 RCX: dffffc0000000000
  [    7.013214][  T150] RDX: ff11000109eca000 RSI: ffffffff9ba9bb00 RDI: ff11000100b4f250
  [    7.014202][  T150] RBP: ffa0000000e17b48 R08: ff11000109ecafff R09: ff11000109eca000
  [    7.015201][  T150] R10: 000000007b3f6fc3 R11: ffffffff9541ea80 R12: ffffffff9ba9bb28
  [    7.016202][  T150] R13: 1fe2200020fdfe80 R14: ffffffff9ba9bb00 R15: ff11000100b4f250
  [    7.017212][  T150] FS:  00007f4818d2b740(0000) GS:0000000000000000(0000) knlGS:0000000000000000
  [    7.018332][  T150] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [    7.019154][  T150] CR2: 00007f481899a000 CR3: 0000000109f3b002 CR4: 0000000000371eb0
  [    7.020147][  T150] Kernel panic - not syncing: Fatal exception
  [    7.020837][  T150] Kernel Offset: 0x12e00000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)

The fix should be something like the following, which resolves the issue
for me.

  nilfs_sysfs_init() ->
    kset_create_and_add() ->
      kset_create()

has

  kset->kobj.ktype = &kset_ktype

which is

  static const struct kobj_type kset_ktype = {
    .sysfs_ops      = &kobj_sysfs_ops,
    .release        = kset_release,
    .get_ownership  = kset_get_ownership,
  };

Note the kobj_sysfs_ops.

  const struct sysfs_ops kobj_sysfs_ops = {
    .show   = kobj_attr_show,
    .store  = kobj_attr_store,
  };

nilfs_feature_attr_group is added to the nilfs_kset->kobj via
sysfs_create_group(), where the kernfs_ops for each file in
nilfs_feature_attr_group becomes

  sysfs_create_group() ->
    internal_create_group() ->
      create_files() ->
        sysfs_add_file_mode_ns() ->
          ops = &sysfs_file_kfops_rw;
          __kernfs_create_file() ->
            kn->attr.ops = ops;

  static const struct kernfs_ops sysfs_file_kfops_rw = {
    .seq_show = sysfs_kf_seq_show,
    .write    = sysfs_kf_write,
  };

sysfs_kf_seq_show() calls kobj_attr_show() via

  const struct sysfs_ops *ops = sysfs_file_ops(of->kn);
  ...
  count = ops->show(kobj, of->kn->priv, buf);

kobj_attr_show() calls one of the nilfs_feature_*_show() functions via
after casting to 'struct kobj_attribute':

  kattr = container_of(attr, struct kobj_attribute, attr);
  if (kattr->show)
    ret = kattr->show(kobj, kattr, buf);

  struct kobj_attribute {
    struct attribute attr;
    ssize_t (*show)(struct kobject *kobj, struct kobj_attribute *attr,
            char *buf);
    ssize_t (*store)(struct kobject *kobj, struct kobj_attribute *attr,
            const char *buf, size_t count);
  };

So the types of nilfs_feature_*_show() need to match
kobj_attribute->show() to avoid triggering CFI here.

Cheers,
Nathan

diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index 14868a3dd592..bc52afbfc5c7 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -1075,7 +1075,7 @@ void nilfs_sysfs_delete_device_group(struct the_nilfs *nilfs)
  ************************************************************************/
 
 static ssize_t nilfs_feature_revision_show(struct kobject *kobj,
-					    struct attribute *attr, char *buf)
+					    struct kobj_attribute *attr, char *buf)
 {
 	return sysfs_emit(buf, "%d.%d\n",
 			NILFS_CURRENT_REV, NILFS_MINOR_REV);
@@ -1087,7 +1087,7 @@ static const char features_readme_str[] =
 	"(1) revision\n\tshow current revision of NILFS file system driver.\n";
 
 static ssize_t nilfs_feature_README_show(struct kobject *kobj,
-					 struct attribute *attr,
+					 struct kobj_attribute *attr,
 					 char *buf)
 {
 	return sysfs_emit(buf, features_readme_str);
diff --git a/fs/nilfs2/sysfs.h b/fs/nilfs2/sysfs.h
index 78a87a016928..d370cd5cce3f 100644
--- a/fs/nilfs2/sysfs.h
+++ b/fs/nilfs2/sysfs.h
@@ -50,16 +50,16 @@ struct nilfs_sysfs_dev_subgroups {
 	struct completion sg_segments_kobj_unregister;
 };
 
-#define NILFS_COMMON_ATTR_STRUCT(name) \
+#define NILFS_KOBJ_ATTR_STRUCT(name) \
 struct nilfs_##name##_attr { \
 	struct attribute attr; \
-	ssize_t (*show)(struct kobject *, struct attribute *, \
+	ssize_t (*show)(struct kobject *, struct kobj_attribute *, \
 			char *); \
-	ssize_t (*store)(struct kobject *, struct attribute *, \
+	ssize_t (*store)(struct kobject *, struct kobj_attribute *, \
 			 const char *, size_t); \
 }
 
-NILFS_COMMON_ATTR_STRUCT(feature);
+NILFS_KOBJ_ATTR_STRUCT(feature);
 
 #define NILFS_DEV_ATTR_STRUCT(name) \
 struct nilfs_##name##_attr { \

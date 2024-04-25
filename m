Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9088A6CDBF
	for <linux-nilfs@vger.kernel.org>; Thu, 25 Apr 2024 08:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714032954; cv=none; b=jVdlrHQux4Fuzzt4NT6V7r81xyc5E36hecoORFWkyf7mf6c5u8tJ+apjIdQt+mGSpp9gISUXfFMjf5NHJ9oowNcXoBtVFY2mTQTnRZNGCdSu+fwikXSOm3JSeVVuznxmRTtiy8dc6RCmzyWtQs4ibNezRvkjFeu8NKpFP0Gqdc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714032954; c=relaxed/simple;
	bh=SAl50haOek2BPzTO+/3IXcCW/MeVu5qNNRlMdSaB4uY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=fkq1xAKVSu+c78WmKzpRCukcoxzBrltAIbxVPGt3BKNRQLQvHZvM4t+eJdUfJOm+hmmB7AjjVTZUj/iscIN1DI2PSfbcY1D75xzhZZRs+q9MfgROwUoxzy+xTbZGCxO2FKFxJYWdKaHYxuWv3g50QFl5xG3B0NQ+MR5cZmYQk+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cY1NXpkI; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cY1NXpkI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714032953; x=1745568953;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=SAl50haOek2BPzTO+/3IXcCW/MeVu5qNNRlMdSaB4uY=;
  b=cY1NXpkImEzzGsnAxxQsw48laS5dD1xF/ClkyChosV6X3CHzzSn0GMj6
   NxyuLNf7Aq1oC9jNilxi56iSU5vB7T5gj3Bm4y5SmGdjAIIkmrOtRb9Go
   Djr/LofRxb35NcDAvQVLrTJqz+TH4DcRdyKx9uhskJJE0DEU6bBs3dA3I
   aIk3Bdph6d/z3tpLfAStswh0dJTdUM7eibWMloBOhM9c/AhR5mNNlG7g+
   UuHRoysmfJEY4PBJfBLjAR1f4Qxa6D4FaT/A2Bn5t3t2mnLBiNwvHPobb
   0ipW+HPmA/diTFVdMLcY7fq8ATtnFmtOkKL6Se2o+H78iACkqAp9i0h8S
   Q==;
X-CSE-ConnectionGUID: GDOtBOLDRNinG6/mzGvGOA==
X-CSE-MsgGUID: CgpR5eSyQOyIPfAmmn5qTQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9815424"
X-IronPort-AV: E=Sophos;i="6.07,228,1708416000"; 
   d="scan'208";a="9815424"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 01:15:52 -0700
X-CSE-ConnectionGUID: kgcJMHwtQcmvYNkDY2Dx4w==
X-CSE-MsgGUID: 7OXbOgQ8QrKGoF6CDNtggg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,228,1708416000"; 
   d="scan'208";a="24991025"
Received: from lkp-server01.sh.intel.com (HELO e434dd42e5a1) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 25 Apr 2024 01:15:49 -0700
Received: from kbuild by e434dd42e5a1 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rzuGg-0002A8-2c;
	Thu, 25 Apr 2024 08:15:46 +0000
Date: Thu, 25 Apr 2024 16:15:21 +0800
From: kernel test robot <lkp@intel.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-nilfs@vger.kernel.org,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: [konis-nilfs2:for-akpm 4/4] fs/nilfs2/super.c:1196:13: warning:
 variable 's' is uninitialized when used here
Message-ID: <202404251609.B6CCB7ts-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://github.com/konis/nilfs2 for-akpm
head:   69812977939c7895ede256e122284c19d4d83aef
commit: 69812977939c7895ede256e122284c19d4d83aef [4/4] nilfs2: convert to use the new mount API
config: s390-defconfig (https://download.01.org/0day-ci/archive/20240425/202404251609.B6CCB7ts-lkp@intel.com/config)
compiler: clang version 19.0.0git (https://github.com/llvm/llvm-project 5ef5eb66fb428aaf61fb51b709f065c069c11242)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240425/202404251609.B6CCB7ts-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202404251609.B6CCB7ts-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from fs/nilfs2/super.c:27:
   In file included from include/linux/module.h:19:
   In file included from include/linux/elf.h:6:
   In file included from arch/s390/include/asm/elf.h:173:
   In file included from arch/s390/include/asm/mmu_context.h:11:
   In file included from arch/s390/include/asm/pgalloc.h:18:
   In file included from include/linux/mm.h:2208:
   include/linux/vmstat.h:508:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     508 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     509 |                            item];
         |                            ~~~~
   include/linux/vmstat.h:515:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     515 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     516 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   include/linux/vmstat.h:522:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     522 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
   include/linux/vmstat.h:527:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     527 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     528 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   include/linux/vmstat.h:536:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     536 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     537 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
>> fs/nilfs2/super.c:1196:13: warning: variable 's' is uninitialized when used here [-Wuninitialized]
    1196 |                 nilfs_err(s, "invalid option \"cp=%llu\": read-only option is not specified",
         |                           ^
   fs/nilfs2/nilfs.h:330:12: note: expanded from macro 'nilfs_err'
     330 |         nilfs_msg(sb, KERN_ERR, fmt, ##__VA_ARGS__)
         |                   ^~
   fs/nilfs2/nilfs.h:308:14: note: expanded from macro 'nilfs_msg'
     308 |         __nilfs_msg(sb, level fmt, ##__VA_ARGS__)
         |                     ^~
   fs/nilfs2/super.c:1191:23: note: initialize the variable 's' to silence this warning
    1191 |         struct super_block *s;
         |                              ^
         |                               = NULL
   6 warnings generated.
--
>> fs/nilfs2/the_nilfs.c:672: warning: Excess function parameter 'data' description in 'init_nilfs'
--
   fs/nilfs2/super.c:122: warning: Function parameter or struct member 'sb' not described in '__nilfs_error'
   fs/nilfs2/super.c:122: warning: Function parameter or struct member 'function' not described in '__nilfs_error'
   fs/nilfs2/super.c:122: warning: Function parameter or struct member 'fmt' not described in '__nilfs_error'
>> fs/nilfs2/super.c:1036: warning: Function parameter or struct member 'fc' not described in 'nilfs_fill_super'
>> fs/nilfs2/super.c:1036: warning: Excess function parameter 'data' description in 'nilfs_fill_super'
>> fs/nilfs2/super.c:1036: warning: Excess function parameter 'silent' description in 'nilfs_fill_super'


vim +/s +1196 fs/nilfs2/super.c

  1024	
  1025	/**
  1026	 * nilfs_fill_super() - initialize a super block instance
  1027	 * @sb: super_block
  1028	 * @data: mount options
  1029	 * @silent: silent mode flag
  1030	 *
  1031	 * This function is called exclusively by nilfs->ns_mount_mutex.
  1032	 * So, the recovery process is protected from other simultaneous mounts.
  1033	 */
  1034	static int
  1035	nilfs_fill_super(struct super_block *sb, struct fs_context *fc)
> 1036	{
  1037		struct the_nilfs *nilfs;
  1038		struct nilfs_root *fsroot;
  1039		struct nilfs_fs_context *ctx = fc->fs_private;
  1040		__u64 cno;
  1041		int err;
  1042	
  1043		nilfs = alloc_nilfs(sb);
  1044		if (!nilfs)
  1045			return -ENOMEM;
  1046	
  1047		sb->s_fs_info = nilfs;
  1048	
  1049		err = init_nilfs(nilfs, sb);
  1050		if (err)
  1051			goto failed_nilfs;
  1052	
  1053		/* Copy in parsed mount options */
  1054		nilfs->ns_mount_opt = ctx->ns_mount_opt;
  1055	
  1056		sb->s_op = &nilfs_sops;
  1057		sb->s_export_op = &nilfs_export_ops;
  1058		sb->s_root = NULL;
  1059		sb->s_time_gran = 1;
  1060		sb->s_max_links = NILFS_LINK_MAX;
  1061	
  1062		sb->s_bdi = bdi_get(sb->s_bdev->bd_disk->bdi);
  1063	
  1064		err = load_nilfs(nilfs, sb);
  1065		if (err)
  1066			goto failed_nilfs;
  1067	
  1068		cno = nilfs_last_cno(nilfs);
  1069		err = nilfs_attach_checkpoint(sb, cno, true, &fsroot);
  1070		if (err) {
  1071			nilfs_err(sb,
  1072				  "error %d while loading last checkpoint (checkpoint number=%llu)",
  1073				  err, (unsigned long long)cno);
  1074			goto failed_unload;
  1075		}
  1076	
  1077		if (!sb_rdonly(sb)) {
  1078			err = nilfs_attach_log_writer(sb, fsroot);
  1079			if (err)
  1080				goto failed_checkpoint;
  1081		}
  1082	
  1083		err = nilfs_get_root_dentry(sb, fsroot, &sb->s_root);
  1084		if (err)
  1085			goto failed_segctor;
  1086	
  1087		nilfs_put_root(fsroot);
  1088	
  1089		if (!sb_rdonly(sb)) {
  1090			down_write(&nilfs->ns_sem);
  1091			nilfs_setup_super(sb, true);
  1092			up_write(&nilfs->ns_sem);
  1093		}
  1094	
  1095		return 0;
  1096	
  1097	 failed_segctor:
  1098		nilfs_detach_log_writer(sb);
  1099	
  1100	 failed_checkpoint:
  1101		nilfs_put_root(fsroot);
  1102	
  1103	 failed_unload:
  1104		nilfs_sysfs_delete_device_group(nilfs);
  1105		iput(nilfs->ns_sufile);
  1106		iput(nilfs->ns_cpfile);
  1107		iput(nilfs->ns_dat);
  1108	
  1109	 failed_nilfs:
  1110		destroy_nilfs(nilfs);
  1111		return err;
  1112	}
  1113	
  1114	static int nilfs_reconfigure(struct fs_context *fc)
  1115	{
  1116		struct nilfs_fs_context *ctx = fc->fs_private;
  1117		struct super_block *sb = fc->root->d_sb;
  1118		struct the_nilfs *nilfs = sb->s_fs_info;
  1119		int err;
  1120	
  1121		sync_filesystem(sb);
  1122	
  1123		err = -EINVAL;
  1124	
  1125		if (!nilfs_valid_fs(nilfs)) {
  1126			nilfs_warn(sb,
  1127				   "couldn't remount because the filesystem is in an incomplete recovery state");
  1128			goto ignore_opts;
  1129		}
  1130		if ((bool)(fc->sb_flags & SB_RDONLY) == sb_rdonly(sb))
  1131			goto out;
  1132		if (fc->sb_flags & SB_RDONLY) {
  1133			sb->s_flags |= SB_RDONLY;
  1134	
  1135			/*
  1136			 * Remounting a valid RW partition RDONLY, so set
  1137			 * the RDONLY flag and then mark the partition as valid again.
  1138			 */
  1139			down_write(&nilfs->ns_sem);
  1140			nilfs_cleanup_super(sb);
  1141			up_write(&nilfs->ns_sem);
  1142		} else {
  1143			__u64 features;
  1144			struct nilfs_root *root;
  1145	
  1146			/*
  1147			 * Mounting a RDONLY partition read-write, so reread and
  1148			 * store the current valid flag.  (It may have been changed
  1149			 * by fsck since we originally mounted the partition.)
  1150			 */
  1151			down_read(&nilfs->ns_sem);
  1152			features = le64_to_cpu(nilfs->ns_sbp[0]->s_feature_compat_ro) &
  1153				~NILFS_FEATURE_COMPAT_RO_SUPP;
  1154			up_read(&nilfs->ns_sem);
  1155			if (features) {
  1156				nilfs_warn(sb,
  1157					   "couldn't remount RDWR because of unsupported optional features (%llx)",
  1158					   (unsigned long long)features);
  1159				err = -EROFS;
  1160				goto ignore_opts;
  1161			}
  1162	
  1163			sb->s_flags &= ~SB_RDONLY;
  1164	
  1165			root = NILFS_I(d_inode(sb->s_root))->i_root;
  1166			err = nilfs_attach_log_writer(sb, root);
  1167			if (err) {
  1168				sb->s_flags |= SB_RDONLY;
  1169				goto ignore_opts;
  1170			}
  1171	
  1172			down_write(&nilfs->ns_sem);
  1173			nilfs_setup_super(sb, true);
  1174			up_write(&nilfs->ns_sem);
  1175		}
  1176	 out:
  1177		sb->s_flags = (sb->s_flags & ~SB_POSIXACL);
  1178		/* Copy over parsed remount options */
  1179		nilfs->ns_mount_opt = ctx->ns_mount_opt;
  1180	
  1181		return 0;
  1182	
  1183	 ignore_opts:
  1184		return err;
  1185	}
  1186	
  1187	static int
  1188	nilfs_get_tree(struct fs_context *fc)
  1189	{
  1190		struct nilfs_fs_context *ctx = fc->fs_private;
  1191		struct super_block *s;
  1192		dev_t dev;
  1193		int err;
  1194	
  1195		if (ctx->cno && !(fc->sb_flags & SB_RDONLY)) {
> 1196			nilfs_err(s, "invalid option \"cp=%llu\": read-only option is not specified",
  1197				ctx->cno);
  1198			return -EINVAL;
  1199		}
  1200	
  1201		err = lookup_bdev(fc->source, &dev);
  1202		if (err)
  1203			return err;
  1204	
  1205		s = sget_dev(fc, dev);
  1206		if (IS_ERR(s))
  1207			return PTR_ERR(s);
  1208	
  1209		if (!s->s_root) {
  1210			err = setup_bdev_super(s, fc->sb_flags, fc);
  1211			if (!err)
  1212				err = nilfs_fill_super(s, fc);
  1213			if (err)
  1214				goto failed_super;
  1215	
  1216			s->s_flags |= SB_ACTIVE;
  1217		} else if (!ctx->cno) {
  1218			if (nilfs_tree_is_busy(s->s_root)) {
  1219				if ((fc->sb_flags ^ s->s_flags) & SB_RDONLY) {
  1220					nilfs_err(s,
  1221						  "the device already has a %s mount.",
  1222						  sb_rdonly(s) ? "read-only" : "read/write");
  1223					err = -EBUSY;
  1224					goto failed_super;
  1225				}
  1226			} else {
  1227				/*
  1228				 * Try remount to setup mount states if the current
  1229				 * tree is not mounted and only snapshots use this sb.
  1230				 */
  1231				fc->root = s->s_root;
  1232				err = nilfs_reconfigure(fc);
  1233				if (err)
  1234					goto failed_super;
  1235			}
  1236		}
  1237	
  1238		if (ctx->cno) {
  1239			struct dentry *root_dentry;
  1240	
  1241			err = nilfs_attach_snapshot(s, ctx->cno, &root_dentry);
  1242			if (err)
  1243				goto failed_super;
  1244			fc->root = root_dentry;
  1245			return 0;
  1246		}
  1247	
  1248		fc->root = dget(s->s_root);
  1249		return 0;
  1250	
  1251	 failed_super:
  1252		deactivate_locked_super(s);
  1253		return err;
  1254	}
  1255	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

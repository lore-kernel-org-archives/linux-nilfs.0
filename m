Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBA882485
	for <linux-nilfs@vger.kernel.org>; Thu, 25 Apr 2024 08:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714034777; cv=none; b=XAzCtDqOWznvTHvOo//6syph2fH7lGj1YbR85r1BYN6ccGNEdfd62LfC6jHjEAcLLOF+nLLCwTowQDQ6JLIh3vgdBWAEpD8sxoEPlwaBrUXafVgKNTp9QSogV9/35vdr+LCJ1fjSnFQn4oAY7CqZcHXMYAjUgBq6Jz/MsszbxOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714034777; c=relaxed/simple;
	bh=bBjhpC03IdhYYab1tuPt9J2+9AZBxHGVTtxGpdqWYRQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YqHNvB0RH8bzpfTd56vR1uZE9lLlj++VdPyeTbaKxW0fQhjxCKtj0huuFtSSIVfh8TCV8e7SB/tCAaugLfhuWkTrxS/BJrk0JdtuCkbzM0X7neqOHYocjRSknxD7TVkQ5oiWNmJdemYVXujPuAOX9HCAGypZYh/dwtlYRt3bSdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gpS7md14; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gpS7md14"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-516d4d80d00so960973e87.0
        for <linux-nilfs@vger.kernel.org>; Thu, 25 Apr 2024 01:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714034774; x=1714639574; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AK9uu/kZ6S6vFi55ZJwmAUQW9PJq0ZZvGIGq/1WJ5Pk=;
        b=gpS7md1457lB4JNMUvkc7RaCITv+hFzz9PburnvG2Pc4qH+bgG5zjIGwB7pyPntdwR
         mNVW2jTiiqJmP8nPmfpkmCzE+rIkn3V0aG40dc+jJF0/2YPRIVpLyWDmAvT9pSe8OcYA
         lvrKrUEAi7VzmV7QGpKIbDrlTQTqLNsTsSbi2HWX6/RUnkYydY9P+Nd0025ySOlaSL8H
         EY+lM7Jugo7BVxGS92NMBc6wBikNgARzG6Ox2BDFZi6fcXP5Gkv1wJq7EUjbV5Qke8QW
         EWXhg/FYgNsC3DLLTeLNt4RcGXnm60CAiNV6CzB/5E/2RNAXUHla0xk3bTtYNKl78RQs
         60iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714034774; x=1714639574;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AK9uu/kZ6S6vFi55ZJwmAUQW9PJq0ZZvGIGq/1WJ5Pk=;
        b=D+E0HZAqWSJpraQ2P5qi0oCGyTIBAZ2IRlVR1QkN9CuLlWGuFkJA9PJs0qp6q3q3qN
         f0e2Yew/WhR9J7rnVgTWImNjKmuklVvST42fINBFsWb5g4jQqClMe3Lu7PfozEj5eH/7
         lPPeTS4Yc3jEB2pJ6X3K9HvxXCkrTmBh4FTv2Kq7gdheu8C8VuRlGKl/mzXoLBZo/CkR
         983yf8Q1REjp5zdNtL7jUXmmKj6i0AL5heZ6PdHwlRESO6kPydUZZp0glNYg2zz0EyPO
         Hc8s3Bc1jxKjgPNUUskvYTRcp6HEjyk82S1B0HVYeIK/eURTFPnNbZy2npVRi0ieBvtj
         1E5Q==
X-Forwarded-Encrypted: i=1; AJvYcCWBDTSK4Uq2uIJvwpuow1Ex7tIBLsCOhsQ/MKAseCnBf8+auRYkGDC0a0YRHLAx5Ewz3jCOOjmZUiQnVkC3gMQiNfkOF5Xd2CJKGnY=
X-Gm-Message-State: AOJu0YzwCLPyCTauzIctjL8f5ci1+KHbotBUqwavVtEltLqsZHGqRTDb
	pnUegaNhhd0pSmb2Sb/ib9Ty6uKViphGAlv7NEJzAe5gg9L6XGbvWHp15UxJoU4XeygQ76giaVs
	Y8QWxpPlOo1Il0e+pPKsvmpfYpls=
X-Google-Smtp-Source: AGHT+IGotLGpAfXviPHeJd/HU+isRq9JC9JroEedruUsnqSvUKCdsQayP95ecKLK6Pcij+DCKSfCW5DKgXbqg5USTFc=
X-Received: by 2002:a05:6512:2805:b0:51a:b955:4014 with SMTP id
 cf5-20020a056512280500b0051ab9554014mr4172691lfb.18.1714034773736; Thu, 25
 Apr 2024 01:46:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-nilfs@vger.kernel.org
List-Id: <linux-nilfs.vger.kernel.org>
List-Subscribe: <mailto:linux-nilfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-nilfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202404251609.B6CCB7ts-lkp@intel.com>
In-Reply-To: <202404251609.B6CCB7ts-lkp@intel.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Thu, 25 Apr 2024 17:45:57 +0900
Message-ID: <CAKFNMo=6GqVkarfY7hu0jag06fzUSHOWSgWEcx12ygr7U7_MSQ@mail.gmail.com>
Subject: Re: [konis-nilfs2:for-akpm 4/4] fs/nilfs2/super.c:1196:13: warning:
 variable 's' is uninitialized when used here
To: kernel test robot <lkp@intel.com>
Cc: Eric Sandeen <sandeen@redhat.com>, llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, 
	linux-nilfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 25, 2024 at 5:15=E2=80=AFPM kernel test robot <lkp@intel.com> w=
rote:
>
> tree:   https://github.com/konis/nilfs2 for-akpm
> head:   69812977939c7895ede256e122284c19d4d83aef
> commit: 69812977939c7895ede256e122284c19d4d83aef [4/4] nilfs2: convert to=
 use the new mount API
> config: s390-defconfig (https://download.01.org/0day-ci/archive/20240425/=
202404251609.B6CCB7ts-lkp@intel.com/config)
> compiler: clang version 19.0.0git (https://github.com/llvm/llvm-project 5=
ef5eb66fb428aaf61fb51b709f065c069c11242)
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20240425/202404251609.B6CCB7ts-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202404251609.B6CCB7ts-lkp=
@intel.com/
>
> All warnings (new ones prefixed by >>):
>
>    In file included from fs/nilfs2/super.c:27:
>    In file included from include/linux/module.h:19:
>    In file included from include/linux/elf.h:6:
>    In file included from arch/s390/include/asm/elf.h:173:
>    In file included from arch/s390/include/asm/mmu_context.h:11:
>    In file included from arch/s390/include/asm/pgalloc.h:18:
>    In file included from include/linux/mm.h:2208:
>    include/linux/vmstat.h:508:43: warning: arithmetic between different e=
numeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-=
enum-conversion]
>      508 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
>          |                            ~~~~~~~~~~~~~~~~~~~~~ ^
>      509 |                            item];
>          |                            ~~~~
>    include/linux/vmstat.h:515:43: warning: arithmetic between different e=
numeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-=
enum-conversion]
>      515 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
>          |                            ~~~~~~~~~~~~~~~~~~~~~ ^
>      516 |                            NR_VM_NUMA_EVENT_ITEMS +
>          |                            ~~~~~~~~~~~~~~~~~~~~~~
>    include/linux/vmstat.h:522:36: warning: arithmetic between different e=
numeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-c=
onversion]
>      522 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip =
"nr_"
>          |                               ~~~~~~~~~~~ ^ ~~~
>    include/linux/vmstat.h:527:43: warning: arithmetic between different e=
numeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-=
enum-conversion]
>      527 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
>          |                            ~~~~~~~~~~~~~~~~~~~~~ ^
>      528 |                            NR_VM_NUMA_EVENT_ITEMS +
>          |                            ~~~~~~~~~~~~~~~~~~~~~~
>    include/linux/vmstat.h:536:43: warning: arithmetic between different e=
numeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-=
enum-conversion]
>      536 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
>          |                            ~~~~~~~~~~~~~~~~~~~~~ ^
>      537 |                            NR_VM_NUMA_EVENT_ITEMS +
>          |                            ~~~~~~~~~~~~~~~~~~~~~~
> >> fs/nilfs2/super.c:1196:13: warning: variable 's' is uninitialized when=
 used here [-Wuninitialized]
>     1196 |                 nilfs_err(s, "invalid option \"cp=3D%llu\": re=
ad-only option is not specified",
>          |                           ^
>    fs/nilfs2/nilfs.h:330:12: note: expanded from macro 'nilfs_err'
>      330 |         nilfs_msg(sb, KERN_ERR, fmt, ##__VA_ARGS__)
>          |                   ^~
>    fs/nilfs2/nilfs.h:308:14: note: expanded from macro 'nilfs_msg'
>      308 |         __nilfs_msg(sb, level fmt, ##__VA_ARGS__)
>          |                     ^~
>    fs/nilfs2/super.c:1191:23: note: initialize the variable 's' to silenc=
e this warning
>     1191 |         struct super_block *s;
>          |                              ^
>          |                               =3D NULL
>    6 warnings generated.
> --
> >> fs/nilfs2/the_nilfs.c:672: warning: Excess function parameter 'data' d=
escription in 'init_nilfs'
> --
>    fs/nilfs2/super.c:122: warning: Function parameter or struct member 's=
b' not described in '__nilfs_error'
>    fs/nilfs2/super.c:122: warning: Function parameter or struct member 'f=
unction' not described in '__nilfs_error'
>    fs/nilfs2/super.c:122: warning: Function parameter or struct member 'f=
mt' not described in '__nilfs_error'
> >> fs/nilfs2/super.c:1036: warning: Function parameter or struct member '=
fc' not described in 'nilfs_fill_super'
> >> fs/nilfs2/super.c:1036: warning: Excess function parameter 'data' desc=
ription in 'nilfs_fill_super'
> >> fs/nilfs2/super.c:1036: warning: Excess function parameter 'silent' de=
scription in 'nilfs_fill_super'
>
>

Again, thanks for the report.

As I answered in another report, I plan to have the patch removed once
and send a revised version.

Ryusuke Konishi

> vim +/s +1196 fs/nilfs2/super.c
>
>   1024
>   1025  /**
>   1026   * nilfs_fill_super() - initialize a super block instance
>   1027   * @sb: super_block
>   1028   * @data: mount options
>   1029   * @silent: silent mode flag
>   1030   *
>   1031   * This function is called exclusively by nilfs->ns_mount_mutex.
>   1032   * So, the recovery process is protected from other simultaneous =
mounts.
>   1033   */
>   1034  static int
>   1035  nilfs_fill_super(struct super_block *sb, struct fs_context *fc)
> > 1036  {
>   1037          struct the_nilfs *nilfs;
>   1038          struct nilfs_root *fsroot;
>   1039          struct nilfs_fs_context *ctx =3D fc->fs_private;
>   1040          __u64 cno;
>   1041          int err;
>   1042
>   1043          nilfs =3D alloc_nilfs(sb);
>   1044          if (!nilfs)
>   1045                  return -ENOMEM;
>   1046
>   1047          sb->s_fs_info =3D nilfs;
>   1048
>   1049          err =3D init_nilfs(nilfs, sb);
>   1050          if (err)
>   1051                  goto failed_nilfs;
>   1052
>   1053          /* Copy in parsed mount options */
>   1054          nilfs->ns_mount_opt =3D ctx->ns_mount_opt;
>   1055
>   1056          sb->s_op =3D &nilfs_sops;
>   1057          sb->s_export_op =3D &nilfs_export_ops;
>   1058          sb->s_root =3D NULL;
>   1059          sb->s_time_gran =3D 1;
>   1060          sb->s_max_links =3D NILFS_LINK_MAX;
>   1061
>   1062          sb->s_bdi =3D bdi_get(sb->s_bdev->bd_disk->bdi);
>   1063
>   1064          err =3D load_nilfs(nilfs, sb);
>   1065          if (err)
>   1066                  goto failed_nilfs;
>   1067
>   1068          cno =3D nilfs_last_cno(nilfs);
>   1069          err =3D nilfs_attach_checkpoint(sb, cno, true, &fsroot);
>   1070          if (err) {
>   1071                  nilfs_err(sb,
>   1072                            "error %d while loading last checkpoint=
 (checkpoint number=3D%llu)",
>   1073                            err, (unsigned long long)cno);
>   1074                  goto failed_unload;
>   1075          }
>   1076
>   1077          if (!sb_rdonly(sb)) {
>   1078                  err =3D nilfs_attach_log_writer(sb, fsroot);
>   1079                  if (err)
>   1080                          goto failed_checkpoint;
>   1081          }
>   1082
>   1083          err =3D nilfs_get_root_dentry(sb, fsroot, &sb->s_root);
>   1084          if (err)
>   1085                  goto failed_segctor;
>   1086
>   1087          nilfs_put_root(fsroot);
>   1088
>   1089          if (!sb_rdonly(sb)) {
>   1090                  down_write(&nilfs->ns_sem);
>   1091                  nilfs_setup_super(sb, true);
>   1092                  up_write(&nilfs->ns_sem);
>   1093          }
>   1094
>   1095          return 0;
>   1096
>   1097   failed_segctor:
>   1098          nilfs_detach_log_writer(sb);
>   1099
>   1100   failed_checkpoint:
>   1101          nilfs_put_root(fsroot);
>   1102
>   1103   failed_unload:
>   1104          nilfs_sysfs_delete_device_group(nilfs);
>   1105          iput(nilfs->ns_sufile);
>   1106          iput(nilfs->ns_cpfile);
>   1107          iput(nilfs->ns_dat);
>   1108
>   1109   failed_nilfs:
>   1110          destroy_nilfs(nilfs);
>   1111          return err;
>   1112  }
>   1113
>   1114  static int nilfs_reconfigure(struct fs_context *fc)
>   1115  {
>   1116          struct nilfs_fs_context *ctx =3D fc->fs_private;
>   1117          struct super_block *sb =3D fc->root->d_sb;
>   1118          struct the_nilfs *nilfs =3D sb->s_fs_info;
>   1119          int err;
>   1120
>   1121          sync_filesystem(sb);
>   1122
>   1123          err =3D -EINVAL;
>   1124
>   1125          if (!nilfs_valid_fs(nilfs)) {
>   1126                  nilfs_warn(sb,
>   1127                             "couldn't remount because the filesyst=
em is in an incomplete recovery state");
>   1128                  goto ignore_opts;
>   1129          }
>   1130          if ((bool)(fc->sb_flags & SB_RDONLY) =3D=3D sb_rdonly(sb)=
)
>   1131                  goto out;
>   1132          if (fc->sb_flags & SB_RDONLY) {
>   1133                  sb->s_flags |=3D SB_RDONLY;
>   1134
>   1135                  /*
>   1136                   * Remounting a valid RW partition RDONLY, so set
>   1137                   * the RDONLY flag and then mark the partition as=
 valid again.
>   1138                   */
>   1139                  down_write(&nilfs->ns_sem);
>   1140                  nilfs_cleanup_super(sb);
>   1141                  up_write(&nilfs->ns_sem);
>   1142          } else {
>   1143                  __u64 features;
>   1144                  struct nilfs_root *root;
>   1145
>   1146                  /*
>   1147                   * Mounting a RDONLY partition read-write, so rer=
ead and
>   1148                   * store the current valid flag.  (It may have be=
en changed
>   1149                   * by fsck since we originally mounted the partit=
ion.)
>   1150                   */
>   1151                  down_read(&nilfs->ns_sem);
>   1152                  features =3D le64_to_cpu(nilfs->ns_sbp[0]->s_feat=
ure_compat_ro) &
>   1153                          ~NILFS_FEATURE_COMPAT_RO_SUPP;
>   1154                  up_read(&nilfs->ns_sem);
>   1155                  if (features) {
>   1156                          nilfs_warn(sb,
>   1157                                     "couldn't remount RDWR because=
 of unsupported optional features (%llx)",
>   1158                                     (unsigned long long)features);
>   1159                          err =3D -EROFS;
>   1160                          goto ignore_opts;
>   1161                  }
>   1162
>   1163                  sb->s_flags &=3D ~SB_RDONLY;
>   1164
>   1165                  root =3D NILFS_I(d_inode(sb->s_root))->i_root;
>   1166                  err =3D nilfs_attach_log_writer(sb, root);
>   1167                  if (err) {
>   1168                          sb->s_flags |=3D SB_RDONLY;
>   1169                          goto ignore_opts;
>   1170                  }
>   1171
>   1172                  down_write(&nilfs->ns_sem);
>   1173                  nilfs_setup_super(sb, true);
>   1174                  up_write(&nilfs->ns_sem);
>   1175          }
>   1176   out:
>   1177          sb->s_flags =3D (sb->s_flags & ~SB_POSIXACL);
>   1178          /* Copy over parsed remount options */
>   1179          nilfs->ns_mount_opt =3D ctx->ns_mount_opt;
>   1180
>   1181          return 0;
>   1182
>   1183   ignore_opts:
>   1184          return err;
>   1185  }
>   1186
>   1187  static int
>   1188  nilfs_get_tree(struct fs_context *fc)
>   1189  {
>   1190          struct nilfs_fs_context *ctx =3D fc->fs_private;
>   1191          struct super_block *s;
>   1192          dev_t dev;
>   1193          int err;
>   1194
>   1195          if (ctx->cno && !(fc->sb_flags & SB_RDONLY)) {
> > 1196                  nilfs_err(s, "invalid option \"cp=3D%llu\": read-=
only option is not specified",
>   1197                          ctx->cno);
>   1198                  return -EINVAL;
>   1199          }
>   1200
>   1201          err =3D lookup_bdev(fc->source, &dev);
>   1202          if (err)
>   1203                  return err;
>   1204
>   1205          s =3D sget_dev(fc, dev);
>   1206          if (IS_ERR(s))
>   1207                  return PTR_ERR(s);
>   1208
>   1209          if (!s->s_root) {
>   1210                  err =3D setup_bdev_super(s, fc->sb_flags, fc);
>   1211                  if (!err)
>   1212                          err =3D nilfs_fill_super(s, fc);
>   1213                  if (err)
>   1214                          goto failed_super;
>   1215
>   1216                  s->s_flags |=3D SB_ACTIVE;
>   1217          } else if (!ctx->cno) {
>   1218                  if (nilfs_tree_is_busy(s->s_root)) {
>   1219                          if ((fc->sb_flags ^ s->s_flags) & SB_RDON=
LY) {
>   1220                                  nilfs_err(s,
>   1221                                            "the device already has=
 a %s mount.",
>   1222                                            sb_rdonly(s) ? "read-on=
ly" : "read/write");
>   1223                                  err =3D -EBUSY;
>   1224                                  goto failed_super;
>   1225                          }
>   1226                  } else {
>   1227                          /*
>   1228                           * Try remount to setup mount states if t=
he current
>   1229                           * tree is not mounted and only snapshots=
 use this sb.
>   1230                           */
>   1231                          fc->root =3D s->s_root;
>   1232                          err =3D nilfs_reconfigure(fc);
>   1233                          if (err)
>   1234                                  goto failed_super;
>   1235                  }
>   1236          }
>   1237
>   1238          if (ctx->cno) {
>   1239                  struct dentry *root_dentry;
>   1240
>   1241                  err =3D nilfs_attach_snapshot(s, ctx->cno, &root_=
dentry);
>   1242                  if (err)
>   1243                          goto failed_super;
>   1244                  fc->root =3D root_dentry;
>   1245                  return 0;
>   1246          }
>   1247
>   1248          fc->root =3D dget(s->s_root);
>   1249          return 0;
>   1250
>   1251   failed_super:
>   1252          deactivate_locked_super(s);
>   1253          return err;
>   1254  }
>   1255
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

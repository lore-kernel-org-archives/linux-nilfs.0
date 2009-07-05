From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Can't start nilfs_cleanerd on root fs.
Date: Sun, 05 Jul 2009 13:56:57 +0900 (JST)
Message-ID: <20090705.135657.105810904.ryusuke@osrg.net>
References: <21e999b60907040743l3940f2a2y1a7b0e56dfe73d73@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Sun_Jul__5_13_56_57_2009_780)--"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <21e999b60907040743l3940f2a2y1a7b0e56dfe73d73-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, quinq.ml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

----Next_Part(Sun_Jul__5_13_56_57_2009_780)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi!
On Sat, 4 Jul 2009 16:43:31 +0200, Quentin RAMEAU wrote:
> Hello,
> 
> I formated my root fs with nilfs a few days ago, but I can't start cleanerd
> for that fs.
> I have another nilfs on that system that seems to work correctly.
> 
> Maybe I am doing something wrong, at least, there something that could be
> done, here is some info about it:
> 
> $ uname -r
> 2.6.30-zen1
> 
> $ mount -t nilfs2
> /dev/hda3 on / type nilfs2 (rw,gcpid=1510)
> /dev/hda4 on /DATA type nilfs2 (rw,gcpid=1675)
> 
> $ ps -ef | grep nilfs
> root      1675     1  0 12:56 ?        00:00:02 /sbin/nilfs_cleanerd -n
> /dev/hda4 /DATA
> 
> $ nilfs_cleanerd /dev/hda3 && tail /var/log/everything/current | grep nilfs
> Jul 04 15:46:29 [nilfs_cleanerd] start
> Jul 04 15:46:29 [nilfs_cleanerd] cannot open nilfs on /dev/hda3: Invalid
> argument
> Jul 04 15:46:29 [nilfs_cleanerd] cannot create cleanerd on /dev/hda3:
> Invalid argument
> Jul 04 15:46:29 [nilfs_cleanerd] shutdown
 
I think this comes from a matching error in /proc/mounts. I found a
symlink entry is used for the device of root filesystem in some
environments.  The current nilfs library does not support such case.

What's going on your /proc/mounts?

Anyway, I wrote a patch to handle the above case.

If this is the case, could you try the following patch?

Thanks in advance,
Ryusuke Konishi

--
diff --git a/lib/nilfs.c b/lib/nilfs.c
index 75179e3..df8792b 100644
--- a/lib/nilfs.c
+++ b/lib/nilfs.c
@@ -148,6 +148,7 @@ static int nilfs_find_fs(struct nilfs *nilfs, const char *dev, const char *dir,
 	int ret, n;
 	char canonical[PATH_MAX + 2];
 	char *cdev = NULL, *cdir = NULL;
+	char *mdev, *mdir;
 
 	ret = -1;
 	if (dev && myrealpath(dev, canonical, sizeof(canonical))) {
@@ -172,20 +173,36 @@ static int nilfs_find_fs(struct nilfs *nilfs, const char *dev, const char *dir,
 		n = tokenize(line, mntent, NMNTFLDS);
 		assert(n == NMNTFLDS);
 
-		if ((dev == NULL || strcmp(mntent[MNTFLD_FS], dev) == 0) &&
-		    (dir == NULL || strcmp(mntent[MNTFLD_DIR], dir) == 0) &&
-		    strcmp(mntent[MNTFLD_TYPE], NILFS_FSTYPE) == 0 &&
-		    has_mntopt(mntent[MNTFLD_OPTS], opt)) {
+		if (strcmp(mntent[MNTFLD_TYPE], NILFS_FSTYPE) != 0)
+			continue;
+
+		if (dir != NULL) {
+			mdir = mntent[MNTFLD_DIR];
+			if (myrealpath(mdir, canonical, sizeof(canonical)))
+				mdir = canonical;
+			if (strcmp(mdir, dir) != 0)
+				continue;
+		}
+
+		if (dev != NULL) {
+			mdev = mntent[MNTFLD_FS];
+			if (myrealpath(mdev, canonical, sizeof(canonical)))
+				mdev = canonical;
+			if (strcmp(mdev, dev) != 0)
+				continue;
+		}
+
+		if (has_mntopt(mntent[MNTFLD_OPTS], opt)) {
 			nilfs->n_dev = strdup(mntent[MNTFLD_FS]);
 			if (nilfs->n_dev == NULL)
-				break;
+				goto failed_proc_mounts;
 			len = strlen(mntent[MNTFLD_DIR]) +
 				strlen(NILFS_IOC) + 2;
 			nilfs->n_ioc = malloc(sizeof(char) * len);
 			if (nilfs->n_ioc == NULL) {
 				free(nilfs->n_dev);
 				nilfs->n_dev = NULL;
-				break;
+				goto failed_proc_mounts;
 			}
 			snprintf(nilfs->n_ioc, len, "%s/%s",
 				 mntent[MNTFLD_DIR], NILFS_IOC);
@@ -193,6 +210,10 @@ static int nilfs_find_fs(struct nilfs *nilfs, const char *dev, const char *dir,
 			break;
 		}
 	}
+	if (ret < 0)
+		errno = ENOENT;
+
+ failed_proc_mounts:
 	fclose(fp);
 
  failed_dir:

----Next_Part(Sun_Jul__5_13_56_57_2009_780)--
Content-Type: Application/Octet-Stream
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="cleanerd-open-failure.patch.bz2"

QlpoOTFBWSZTWSUdmNsAAlTfgEAwc3///29n3mq/799+UANYnrRgoAEiQhJP0PU0UxqD1APUeoBk
2poNAaNG0gOGmmRiMJpgIYBNMIwTEyGmRoaAZqKp+qekeptTQAGgAAAAAAAA4aaZGIwmmAhgE0wj
BMTIaZGhoBFIQCNE9Jij0gNAAAAAyaHqA0JGwYNNItrAUCQxiECEoZKmRwmDkSIUNRBCBAnA4EwY
K3+ZtJhyfwpHdIqvJcXFCGJXqipxLogJ6aTcdWVS1S/mjsYJivUYlu/WSXC5/NCilGk/2pHL3bnb
41rRrZ8t86tx01qx6HB0lU5SJ5cuzHnBiO3fkuoqG9QUhHBZiWPYqtjqyOpO4YIh1vOVOofUZx3d
zs4BRNvEEjX0RX8w5dTdrWAyhDo7noaxrslRleHtbZkufbOk7KhCVtH06WrnhhFdib1k2gSFnwEP
Jsdqyut2RR5kwnJ4aLJFVn4uPkbqLwDzIyJSpAcb6Ng2FmLkgTOt4pz3uBvbBssnQ9s3op7PPeWT
M2OJmLPFx37pPDT3lGDjdp1XW0KFDsGBqfPFlTy8qZDRBCQaUvQLqs368n1N4YI0KqSMyNSVBLmC
ZyBRDlR5g+6FVZvUwPTD5zFGSFpXYWbw0FQZzMGJCWi/fSegwKIUrDyKbt9nASlEHHEswSIYN8g4
w/PZYZMj0M3YdwONoh/JMkPcDze9ydNx/Aq+J7nlIoySEONrHlLJDBPR4xoNxV/XTwsNpwas45PE
ORK9Rbl8lLqEXFqkXPHv/6+/35FYLUDaOLaDaGV9buBNiOzaFtMgtr4HVtxZsIHimXOwSudQUdSF
yOHyCYJi9CzFs03OLeL/r8gzOUIZBfeYEwTmDgrxyk15XbrCc5E6SiIgiA0pYM5nRrlIJ/5cyYoT
bm+20iDOFTdjnQ0XjgFQPEDKbI3M3LWSNUXtoUqQyQkZizhLxvh20bdbnDPoAgIiIAwXkedu1cOj
rWGqTqJtjzwgRJk5jPrucMKtI0aEEbZREnA02jsbAxNEEq4UqYRvGHMXyKAw2MNHdYCa3BLR3kGh
P+LuSKcKEgSjsxtg

----Next_Part(Sun_Jul__5_13_56_57_2009_780)--
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

----Next_Part(Sun_Jul__5_13_56_57_2009_780)----

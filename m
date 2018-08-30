From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH] nilfs2: convert to SPDX license tags
Date: Thu, 30 Aug 2018 19:22:08 +0900
Message-ID: <1535624528-5982-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:lines;
        bh=Q2xt83E1N21rSC8KV1A8jl0qvyFlvqERKWOsBtMxSIM=;
        b=LZqoK+XGuzjnirKL38pxck4NCyWNaEESaJKlrY/KYWhr6fQkvp62T3ySzwpvfNCafK
         vaFZi1rG0z8R2ml+m04FSaCblzUPClL0APp1pXGuwodrBT7wFIxxglH07T+iRMOG4VQw
         j1KM9+HbBZuwFNxw26hhBxwvZn4Ot692BC+163AyH+cp5AOhqFvpYwwpMTt+Fy4AlFHN
         ypkg+pwrXX6lk7wNvKs8j/0D6tk/RUk5ICeUKRssOdsDtWA5axtjbG30+CSk1YODItAX
         OVy6QeT2vINdRNJl1rR7RYZTem8NxiJmqXVwDwo5qrb/a5NnHqV9bIfvRzV1IZd65Fkk
         byIg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-nilfs <linux-nilfs@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Remove the verbose license text from NILFS2 files and replace them
with SPDX tags.  This does not change the license of any of the code.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/alloc.c     | 11 +----------
 fs/nilfs2/alloc.h     | 11 +----------
 fs/nilfs2/bmap.c      | 11 +----------
 fs/nilfs2/bmap.h      | 11 +----------
 fs/nilfs2/btnode.c    | 11 +----------
 fs/nilfs2/btnode.h    | 11 +----------
 fs/nilfs2/btree.c     | 11 +----------
 fs/nilfs2/btree.h     | 11 +----------
 fs/nilfs2/cpfile.c    | 11 +----------
 fs/nilfs2/cpfile.h    | 11 +----------
 fs/nilfs2/dat.c       | 11 +----------
 fs/nilfs2/dat.h       | 11 +----------
 fs/nilfs2/dir.c       | 11 +----------
 fs/nilfs2/direct.c    | 11 +----------
 fs/nilfs2/direct.h    | 11 +----------
 fs/nilfs2/file.c      | 11 +----------
 fs/nilfs2/gcinode.c   | 11 +----------
 fs/nilfs2/ifile.c     | 11 +----------
 fs/nilfs2/ifile.h     | 11 +----------
 fs/nilfs2/inode.c     | 11 +----------
 fs/nilfs2/ioctl.c     | 11 +----------
 fs/nilfs2/mdt.c       | 11 +----------
 fs/nilfs2/mdt.h       | 11 +----------
 fs/nilfs2/namei.c     | 11 +----------
 fs/nilfs2/nilfs.h     | 11 +----------
 fs/nilfs2/page.c      | 11 +----------
 fs/nilfs2/page.h      | 11 +----------
 fs/nilfs2/recovery.c  | 11 +----------
 fs/nilfs2/segbuf.c    | 11 +----------
 fs/nilfs2/segbuf.h    | 11 +----------
 fs/nilfs2/segment.c   | 11 +----------
 fs/nilfs2/segment.h   | 11 +----------
 fs/nilfs2/sufile.c    | 11 +----------
 fs/nilfs2/sufile.h    | 11 +----------
 fs/nilfs2/super.c     | 11 +----------
 fs/nilfs2/sysfs.c     | 11 +----------
 fs/nilfs2/sysfs.h     | 11 +----------
 fs/nilfs2/the_nilfs.c | 11 +----------
 fs/nilfs2/the_nilfs.h | 11 +----------
 39 files changed, 39 insertions(+), 390 deletions(-)

diff --git a/fs/nilfs2/alloc.c b/fs/nilfs2/alloc.c
index 03b8ba9..235b959 100644
--- a/fs/nilfs2/alloc.c
+++ b/fs/nilfs2/alloc.c
@@ -1,18 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * alloc.c - NILFS dat/inode allocator
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Originally written by Koji Sato.
  * Two allocators were unified by Ryusuke Konishi and Amagai Yoshiji.
  */
diff --git a/fs/nilfs2/alloc.h b/fs/nilfs2/alloc.h
index 05149e6..0303c39 100644
--- a/fs/nilfs2/alloc.h
+++ b/fs/nilfs2/alloc.h
@@ -1,18 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * alloc.h - persistent object (dat entry/disk inode) allocator/deallocator
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Originally written by Koji Sato.
  * Two allocators were unified by Ryusuke Konishi and Amagai Yoshiji.
  */
diff --git a/fs/nilfs2/bmap.c b/fs/nilfs2/bmap.c
index 01fb183..fb5a9a8 100644
--- a/fs/nilfs2/bmap.c
+++ b/fs/nilfs2/bmap.c
@@ -1,18 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * bmap.c - NILFS block mapping.
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Written by Koji Sato.
  */
 
diff --git a/fs/nilfs2/bmap.h b/fs/nilfs2/bmap.h
index 2b6ffbe..2c63858e 100644
--- a/fs/nilfs2/bmap.h
+++ b/fs/nilfs2/bmap.h
@@ -1,18 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * bmap.h - NILFS block mapping.
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Written by Koji Sato.
  */
 
diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index dec98ca..ebb24a3 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -1,18 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * btnode.c - NILFS B-tree node cache
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Originally written by Seiji Kihara.
  * Fully revised by Ryusuke Konishi for stabilization and simplification.
  *
diff --git a/fs/nilfs2/btnode.h b/fs/nilfs2/btnode.h
index 4e8aaa1..0f88dbc 100644
--- a/fs/nilfs2/btnode.h
+++ b/fs/nilfs2/btnode.h
@@ -1,18 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * btnode.h - NILFS B-tree node cache
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Written by Seiji Kihara.
  * Revised by Ryusuke Konishi.
  */
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 16a7a67..23e043e 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -1,18 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * btree.c - NILFS B-tree.
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Written by Koji Sato.
  */
 
diff --git a/fs/nilfs2/btree.h b/fs/nilfs2/btree.h
index 2184e47..d1421b6 100644
--- a/fs/nilfs2/btree.h
+++ b/fs/nilfs2/btree.h
@@ -1,18 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * btree.h - NILFS B-tree.
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Written by Koji Sato.
  */
 
diff --git a/fs/nilfs2/cpfile.c b/fs/nilfs2/cpfile.c
index a15a160..8d41311 100644
--- a/fs/nilfs2/cpfile.c
+++ b/fs/nilfs2/cpfile.c
@@ -1,18 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * cpfile.c - NILFS checkpoint file.
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Written by Koji Sato.
  */
 
diff --git a/fs/nilfs2/cpfile.h b/fs/nilfs2/cpfile.h
index 6eca972..6336222 100644
--- a/fs/nilfs2/cpfile.h
+++ b/fs/nilfs2/cpfile.h
@@ -1,18 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * cpfile.h - NILFS checkpoint file.
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Written by Koji Sato.
  */
 
diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index dffedb2..6f40666 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -1,18 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * dat.c - NILFS disk address translation.
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Written by Koji Sato.
  */
 
diff --git a/fs/nilfs2/dat.h b/fs/nilfs2/dat.h
index 57dc6cf..b17ee34 100644
--- a/fs/nilfs2/dat.h
+++ b/fs/nilfs2/dat.h
@@ -1,18 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * dat.h - NILFS disk address translation.
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Written by Koji Sato.
  */
 
diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
index 582831a..81394e2 100644
--- a/fs/nilfs2/dir.c
+++ b/fs/nilfs2/dir.c
@@ -1,18 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * dir.c - NILFS directory entry operations
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Modified for NILFS by Amagai Yoshiji.
  */
 /*
diff --git a/fs/nilfs2/direct.c b/fs/nilfs2/direct.c
index 96e3ed0..533e24e 100644
--- a/fs/nilfs2/direct.c
+++ b/fs/nilfs2/direct.c
@@ -1,18 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * direct.c - NILFS direct block pointer.
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Written by Koji Sato.
  */
 
diff --git a/fs/nilfs2/direct.h b/fs/nilfs2/direct.h
index cfe85e8..ec9a23c 100644
--- a/fs/nilfs2/direct.h
+++ b/fs/nilfs2/direct.h
@@ -1,18 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * direct.h - NILFS direct block pointer.
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Written by Koji Sato.
  */
 
diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index 7da0fac..64bc813 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -1,18 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * file.c - NILFS regular file handling primitives including fsync().
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Written by Amagai Yoshiji and Ryusuke Konishi.
  */
 
diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index 853a831..aa3c328 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -1,18 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * gcinode.c - dummy inodes to buffer blocks for garbage collection
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Written by Seiji Kihara, Amagai Yoshiji, and Ryusuke Konishi.
  * Revised by Ryusuke Konishi.
  *
diff --git a/fs/nilfs2/ifile.c b/fs/nilfs2/ifile.c
index b8fa45c..4140d23 100644
--- a/fs/nilfs2/ifile.c
+++ b/fs/nilfs2/ifile.c
@@ -1,18 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * ifile.c - NILFS inode file
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Written by Amagai Yoshiji.
  * Revised by Ryusuke Konishi.
  *
diff --git a/fs/nilfs2/ifile.h b/fs/nilfs2/ifile.h
index 188b94f..a1e1e57 100644
--- a/fs/nilfs2/ifile.h
+++ b/fs/nilfs2/ifile.h
@@ -1,18 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * ifile.h - NILFS inode file
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Written by Amagai Yoshiji.
  * Revised by Ryusuke Konishi.
  *
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 6a612d8..6710855 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -1,18 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * inode.c - NILFS inode operations.
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Written by Ryusuke Konishi.
  *
  */
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 1d2c3d7..9b96d79 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -1,18 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * ioctl.c - NILFS ioctl operations.
  *
  * Copyright (C) 2007, 2008 Nippon Telegraph and Telephone Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Written by Koji Sato.
  */
 
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index c6bc103..700870a 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -1,18 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * mdt.c - meta data file for NILFS
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Written by Ryusuke Konishi.
  */
 
diff --git a/fs/nilfs2/mdt.h b/fs/nilfs2/mdt.h
index 3f67f39..e77aea4 100644
--- a/fs/nilfs2/mdt.h
+++ b/fs/nilfs2/mdt.h
@@ -1,18 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * mdt.h - NILFS meta data file prototype and definitions
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Written by Ryusuke Konishi.
  */
 
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index dd52d3f..9fe6d4a 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -1,18 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * namei.c - NILFS pathname lookup operations.
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Modified for NILFS by Amagai Yoshiji and Ryusuke Konishi.
  */
 /*
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 33f8c8f..a2f247b 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -1,18 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * nilfs.h - NILFS local header file.
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Written by Koji Sato and Ryusuke Konishi.
  */
 
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 4cb850a..329a056 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -1,18 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * page.c - buffer/page management specific to NILFS
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Written by Ryusuke Konishi and Seiji Kihara.
  */
 
diff --git a/fs/nilfs2/page.h b/fs/nilfs2/page.h
index f3687c9..62b9bb4 100644
--- a/fs/nilfs2/page.h
+++ b/fs/nilfs2/page.h
@@ -1,18 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * page.h - buffer/page management specific to NILFS
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Written by Ryusuke Konishi and Seiji Kihara.
  */
 
diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index 5139efe..140b663 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -1,18 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * recovery.c - NILFS recovery logic
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Written by Ryusuke Konishi.
  */
 
diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index 68cb9e4..20c479b 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -1,18 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * segbuf.c - NILFS segment buffer
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Written by Ryusuke Konishi.
  *
  */
diff --git a/fs/nilfs2/segbuf.h b/fs/nilfs2/segbuf.h
index 10e1693..9bea1bd 100644
--- a/fs/nilfs2/segbuf.h
+++ b/fs/nilfs2/segbuf.h
@@ -1,18 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * segbuf.h - NILFS Segment buffer prototypes and definitions
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Written by Ryusuke Konishi.
  *
  */
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 0953635..445eef4 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1,18 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * segment.c - NILFS segment constructor.
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Written by Ryusuke Konishi.
  *
  */
diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
index 04634e3..f5cf530 100644
--- a/fs/nilfs2/segment.h
+++ b/fs/nilfs2/segment.h
@@ -1,18 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * segment.h - NILFS Segment constructor prototypes and definitions
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Written by Ryusuke Konishi.
  *
  */
diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
index c7fa139..bf3f8f0 100644
--- a/fs/nilfs2/sufile.c
+++ b/fs/nilfs2/sufile.c
@@ -1,18 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * sufile.c - NILFS segment usage file.
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Written by Koji Sato.
  * Revised by Ryusuke Konishi.
  */
diff --git a/fs/nilfs2/sufile.h b/fs/nilfs2/sufile.h
index 673a891..c4e2c7a 100644
--- a/fs/nilfs2/sufile.h
+++ b/fs/nilfs2/sufile.h
@@ -1,18 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * sufile.h - NILFS segment usage file.
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Written by Koji Sato.
  */
 
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 1b9067c..26290aa 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1,18 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * super.c - NILFS module and super block management.
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Written by Ryusuke Konishi.
  */
 /*
diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index 4b25837..e60be7b 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -1,19 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * sysfs.c - sysfs support implementation.
  *
  * Copyright (C) 2005-2014 Nippon Telegraph and Telephone Corporation.
  * Copyright (C) 2014 HGST, Inc., a Western Digital Company.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Written by Vyacheslav Dubeyko <Vyacheslav.Dubeyko@hgst.com>
  */
 
diff --git a/fs/nilfs2/sysfs.h b/fs/nilfs2/sysfs.h
index 648cedf..d001eb86 100644
--- a/fs/nilfs2/sysfs.h
+++ b/fs/nilfs2/sysfs.h
@@ -1,19 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * sysfs.h - sysfs support declarations.
  *
  * Copyright (C) 2005-2014 Nippon Telegraph and Telephone Corporation.
  * Copyright (C) 2014 HGST, Inc., a Western Digital Company.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Written by Vyacheslav Dubeyko <Vyacheslav.Dubeyko@hgst.com>
  */
 
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 1a85317..484785c 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -1,18 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * the_nilfs.c - the_nilfs shared structure.
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Written by Ryusuke Konishi.
  *
  */
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 36da177..380a543 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -1,18 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
 /*
  * the_nilfs.h - the_nilfs shared structure.
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
  * Written by Ryusuke Konishi.
  *
  */
-- 
1.8.3.1


From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH 1/2] nilfs-utils: change library license to LGPL
Date: Fri, 19 Nov 2010 19:23:01 +0900
Message-ID: <1290162182-31605-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1290155467-5475-1-git-send-email-jir@unicus.jp>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1290155467-5475-1-git-send-email-jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

This changes the license of remaining library code to the GNU Lesser
General Public License.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---
 include/nilfs.h |   18 ++++++++----------
 lib/cno.c       |   10 +++++-----
 lib/nilfs.c     |   18 ++++++++----------
 lib/sb.c        |   10 +++++-----
 4 files changed, 26 insertions(+), 30 deletions(-)

diff --git a/include/nilfs.h b/include/nilfs.h
index 8a83dd3..af2584e 100644
--- a/include/nilfs.h
+++ b/include/nilfs.h
@@ -1,22 +1,20 @@
 /*
  * nilfs.h - NILFS header file.
  *
- * Copyright (C) 2007 Nippon Telegraph and Telephone Corporation.
+ * Copyright (C) 2007-2010 Nippon Telegraph and Telephone Corporation.
  *
- * This file is part of NILFS.
- *
- * NILFS is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License as published
+ * by the Free Software Foundation; either version 2.1 of the License, or
  * (at your option) any later version.
  *
- * NILFS is distributed in the hope that it will be useful,
+ * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
+ * GNU Lesser General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with NILFS; if not, write to the Free Software
+ * You should have received a copy of the GNU Lesser General Public License
+ * along with this program; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
  * Written by Koji Sato <koji-sG5X7nlA6pw@public.gmane.org>.
diff --git a/lib/cno.c b/lib/cno.c
index f08f5e7..90aa84b 100644
--- a/lib/cno.c
+++ b/lib/cno.c
@@ -1,19 +1,19 @@
 /*
  * cno.c - NILFS checkpoint number parser
  *
- * Copyright (C) 2009 Nippon Telegraph and Telephone Corporation.
+ * Copyright (C) 2009-2010 Nippon Telegraph and Telephone Corporation.
  *
  * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
+ * it under the terms of the GNU Lesser General Public License as published
+ * by the Free Software Foundation; either version 2.1 of the License, or
  * (at your option) any later version.
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
+ * GNU Lesser General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
+ * You should have received a copy of the GNU Lesser General Public License
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
diff --git a/lib/nilfs.c b/lib/nilfs.c
index 19bf6e4..3ba5571 100644
--- a/lib/nilfs.c
+++ b/lib/nilfs.c
@@ -1,22 +1,20 @@
 /*
  * nilfs.c - NILFS library.
  *
- * Copyright (C) 2007 Nippon Telegraph and Telephone Corporation.
+ * Copyright (C) 2007-2010 Nippon Telegraph and Telephone Corporation.
  *
- * This file is part of NILFS.
- *
- * NILFS is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License as published
+ * by the Free Software Foundation; either version 2.1 of the License, or
  * (at your option) any later version.
  *
- * NILFS is distributed in the hope that it will be useful,
+ * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
+ * GNU Lesser General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with NILFS; if not, write to the Free Software
+ * You should have received a copy of the GNU Lesser General Public License
+ * along with this program; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
  * Written by Koji Sato <koji-sG5X7nlA6pw@public.gmane.org>.
diff --git a/lib/sb.c b/lib/sb.c
index d93504c..c7d40c4 100644
--- a/lib/sb.c
+++ b/lib/sb.c
@@ -1,19 +1,19 @@
 /*
  * sb.c - NILFS super block access library
  *
- * Copyright (C) 2005-2009 Nippon Telegraph and Telephone Corporation.
+ * Copyright (C) 2005-2010 Nippon Telegraph and Telephone Corporation.
  *
  * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
+ * it under the terms of the GNU Lesser General Public License as published
+ * by the Free Software Foundation; either version 2.1 of the License, or
  * (at your option) any later version.
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
+ * GNU Lesser General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
+ * You should have received a copy of the GNU Lesser General Public License
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
-- 
1.7.3.2

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

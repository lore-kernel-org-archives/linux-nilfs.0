From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH] radix tree test suite: fix mapshift build target
Date: Thu, 12 Apr 2018 15:05:18 -0600
Message-ID: <20180412210518.27557-1-ross.zwisler@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Matthew Wilcox <mawilcox@microsoft.com>, LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org

The following commit

  commit c6ce3e2fe3da ("radix tree test suite: Add config option for map
  shift")

Introduced a phony makefile target called 'mapshift' that ends up
generating the file generated/map-shift.h.  This phony target was then
added as a dependency of the top level 'targets' build target, which is
what is run when you go to tools/testing/radix-tree and just type 'make'.

Unfortunately, this phony target doesn't actually work as a dependency, so
you end up getting:

$ make
make: *** No rule to make target 'generated/map-shift.h', needed by 'main.o'.  Stop.
make: *** Waiting for unfinished jobs....

Fix this by making the file generated/map-shift.h our real makefile target,
and add this a dependency of the top level build target.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---

This allows the radix tree test suite that shipped with v4.16 build and
run successfully.

The radix tree test suite in the current linux/master during the v4.17
merge window is broken, as I've reported here:

https://marc.info/?l=linux-fsdevel&m=152356678901014&w=2

But this patch is necessary to even get to that breakage.

I've sent this to Matthew twice with no response, so Andrew, I'm trying
you next.

---
 tools/testing/radix-tree/Makefile | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/testing/radix-tree/Makefile b/tools/testing/radix-tree/Makefile
index fa7ee369b3c9..db66f8a0d4be 100644
--- a/tools/testing/radix-tree/Makefile
+++ b/tools/testing/radix-tree/Makefile
@@ -17,7 +17,7 @@ ifeq ($(BUILD), 32)
 	LDFLAGS += -m32
 endif
 
-targets: mapshift $(TARGETS)
+targets: generated/map-shift.h $(TARGETS)
 
 main:	$(OFILES)
 
@@ -42,9 +42,7 @@ radix-tree.c: ../../../lib/radix-tree.c
 idr.c: ../../../lib/idr.c
 	sed -e 's/^static //' -e 's/__always_inline //' -e 's/inline //' < $< > $@
 
-.PHONY: mapshift
-
-mapshift:
+generated/map-shift.h:
 	@if ! grep -qws $(SHIFT) generated/map-shift.h; then		\
 		echo "#define RADIX_TREE_MAP_SHIFT $(SHIFT)" >		\
 				generated/map-shift.h;			\
-- 
2.14.3


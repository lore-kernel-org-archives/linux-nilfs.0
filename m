From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v2] nilfs-utils: mkfs.nilfs2 should check presence of
 NILFS2 volume on device
Date: Sun, 24 Mar 2013 21:55:40 +0900 (JST)
Message-ID: <20130324.215540.27791752.konishi.ryusuke@lab.ntt.co.jp>
References: <1364126337.9937.2.camel@slavad-ubuntu-12.04>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1364126337.9937.2.camel-dzAnj6fV1RxGeWtTaGDT1UEK6ufn8VP3@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hendrik-j5CO6tLloWodnm+yROfE0A@public.gmane.org

Hi,
On Sun, 24 Mar 2013 15:58:57 +0400, Vyacheslav Dubeyko wrote:
> From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> Subject: [PATCH v2] nilfs-utils: mkfs.nilfs2 should check presence of NILFS2 volume on device
> 
> The mkfs.nilfs2 utility should check presence of NILFS2 volume on device and to warn a user about possibility to destroy data by mkfs activity. This patch tries to read and to validate checksums of primary and secondary superblocks on opened device. If this operation ends successfully then mkfs.nilfs2 informs a user about potential danger to destroy existing NILFS2 volume. The execution of mkfs.nilfs2 stops with offering to make decision about continuation or abortion of operation.
> 
> Moreover, this patch adds "-f" option that gives opportunity to force overwrite when an existing NILFS2 filesystem is detected on the device. By default, mkfs.nilfs2 will not write to the device if it suspects that there is a filesystem on the device already. The man page of mkfs.nilfs2 was modified by description of "-f" option.
> 
> Reported-by: Hendrik Levsen <hendrik-j5CO6tLloWodnm+yROfE0A@public.gmane.org>
> Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
> Tested-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>

I noticed that the prompt "Continue? [y/N]" doesn't work as expected
for an enter key input.

Moreover, this patch looks to break alphabetical order of options;
"-f" option should be inserted after "-c" option.

Regards,
Ryusuke Konishi

> ---
>  man/mkfs.nilfs2.8     |   13 +++++++++++++
>  sbin/mkfs/Makefile.am |    3 ++-
>  sbin/mkfs/mkfs.c      |   42 ++++++++++++++++++++++++++++++++++++++++--
>  3 files changed, 55 insertions(+), 3 deletions(-)
> 
> diff --git a/man/mkfs.nilfs2.8 b/man/mkfs.nilfs2.8
> index 6b7dffe..56dbaba 100644
> --- a/man/mkfs.nilfs2.8
> +++ b/man/mkfs.nilfs2.8
> @@ -15,6 +15,9 @@ mkfs.nilfs2 \- create a NILFS2 filesystem
>  .I blocks-per-segment
>  ]
>  [
> +.B \-f
> +]
> +[
>  .B \-c
>  ]
>  [
> @@ -59,6 +62,9 @@ mkfs.nilfs2 \- create a NILFS2 filesystem
>  .I blocks-per-segment
>  ]
>  [
> +.B \-f
> +]
> +[
>  .B \-c
>  ]
>  [
> @@ -117,6 +123,13 @@ This parameter gives the size of segment and consequently determines
>  how many segments are aligned in the specified device.  The default
>  number of blocks per segment is 2048 (= 8MB with 4KB blocks).
>  .TP
> +.B \-f
> +Force overwrite when an existing filesystem is detected on the device.
> +By default,
> +.B mkfs.nilfs2
> +will not write to the device if it suspects  that  there is a filesystem
> +on the device already.
> +.TP
>  .B \-c
>  Check the device for bad blocks before building the filesystem.
>  .TP
> diff --git a/sbin/mkfs/Makefile.am b/sbin/mkfs/Makefile.am
> index b3eb78a..631b04f 100644
> --- a/sbin/mkfs/Makefile.am
> +++ b/sbin/mkfs/Makefile.am
> @@ -4,7 +4,8 @@ AM_CFLAGS = -Wall
>  AM_CPPFLAGS = -I$(top_srcdir)/include
>  LDADD = -luuid $(top_builddir)/lib/libnilfsfeature.la \
>  	$(top_builddir)/lib/libmountchk.la \
> -	$(top_builddir)/lib/libcrc32.la
> +	$(top_builddir)/lib/libcrc32.la \
> +	$(top_builddir)/lib/libnilfs.la
>  
>  sbin_PROGRAMS = mkfs.nilfs2
>  
> diff --git a/sbin/mkfs/mkfs.c b/sbin/mkfs/mkfs.c
> index fde1c76..b88446a 100644
> --- a/sbin/mkfs/mkfs.c
> +++ b/sbin/mkfs/mkfs.c
> @@ -112,6 +112,7 @@ static int cflag = 0;
>  static int nflag = 0;
>  static int verbose = 0;
>  static int discard = 1;
> +static int force_overwrite = 0;
>  static unsigned long blocksize = NILFS_DEF_BLOCKSIZE;
>  static unsigned long blocks_per_segment = NILFS_DEF_BLKS_PER_SEG;
>  static unsigned long r_segments_percentage = NILFS_DEF_RESERVED_SEGMENTS;
> @@ -347,6 +348,8 @@ static int nilfs_mkfs_discard_zeroes_data(int fd)
>  
>  static void disk_scan(const char *device);
>  static void check_mount(int fd, const char *device);
> +static void check_presence_of_nilfs_volume_on_device(int fd,
> +						const char *device);
>  
>  
>  /*
> @@ -611,6 +614,7 @@ int main(int argc, char *argv[])
>  	if ((fd = open(device, O_RDWR)) < 0)
>  		perr("Error: cannot open device: %s", device);
>  	check_mount(fd, device);
> +	check_presence_of_nilfs_volume_on_device(fd, device);
>  
>  	init_disk_layout(di, fd, device);
>  	si = new_segment(di);
> @@ -729,6 +733,37 @@ static void check_mount(int fd, const char *device)
>  	fclose(fp);
>  }
>  
> +static void check_presence_of_nilfs_volume_on_device(int fd,
> +						const char *device)
> +{
> +	struct nilfs_super_block *sbp = NULL;
> +	int c;
> +
> +	if (force_overwrite == 0) {
> +		sbp = nilfs_sb_read(fd);
> +		if (sbp) {
> +			free(sbp);
> +
> +			pinfo("WARNING: Device %s has NILFS2 superblocks.",
> +				device);
> +			pinfo("WARNING: All data will be lost after format!");
> +			pinfo("\nDO YOU REALLY WANT TO FORMAT DEVICE %s?",
> +				device);
> +
> +			do {
> +				fprintf(stderr, "\nContinue? [y/N] ");
> +				c = getchar();
> +
> +				if (c == 'n' || c == 'N' || c == EOF) {
> +					close(fd);
> +					perr("Abort format of device %s",
> +						device);
> +				}
> +			} while (c != 'y' && c != 'Y');
> +		}
> +	}
> +}
> +
>  static void destroy_disk_buffer(void)
>  {
>  	if (disk_buffer) {
> @@ -973,7 +1008,7 @@ static void parse_options(int argc, char *argv[])
>  	int c, show_version_only = 0;
>  	char *fs_features = NULL;
>  
> -	while ((c = getopt(argc, argv, "b:B:chKL:m:nqvO:P:V")) != EOF) {
> +	while ((c = getopt(argc, argv, "b:B:fchKL:m:nqvO:P:V")) != EOF) {
>  		switch (c) {
>  		case 'b':
>  			blocksize = atol(optarg);
> @@ -982,6 +1017,9 @@ static void parse_options(int argc, char *argv[])
>  		case 'B':
>  			blocks_per_segment = atol(optarg);
>  			break;
> +		case 'f':
> +			force_overwrite = 1;
> +			break;
>  		case 'c':
>  			cflag++;
>  			break;
> @@ -1056,7 +1094,7 @@ static void parse_options(int argc, char *argv[])
>  static void usage(void)
>  {
>  	fprintf(stderr,
> -		"Usage: %s [-b block-size] [-B blocks-per-segment] [-c] \n"
> +		"Usage: %s [-b block-size] [-B blocks-per-segment] [-f] [-c] \n"
>  		"       [-L volume-label] [-m reserved-segments-percentage] \n"
>  		"       [-O feature[,...]] \n"
>  		"       [-hnqvKV] device\n",
> -- 
> 1.7.9.5
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: [PATCH] lscp: always display NBLKINC and BLKCNT
Date: Wed, 02 Mar 2011 13:07:54 +0900 (JST)
Message-ID: <20110302.130754.77330610.ryusuke@osrg.net>
References: <201103011357.01138.dexen.devries@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201103011357.01138.dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Tue, 1 Mar 2011 13:57:00 +0100, dexen deVries wrote:
> Makes lscp display both NBLKINC and BLKCNT at the same time, in that order; 
> gets rid of options to display either of them.
> 
> I'm sorry it's almost exactly a revert of Ryusuke's recent patch ;-)
> 
> - dVdx

Thanks for the patch, but currently no nilfs' in mainline kernels are
supporting this feature.  The block count patch is intended for
2.6.39, and it takes further time until the new kernel replaces
distributed kernels.

I think it's too early to exhibit it now though I'd like to switch the
two fields or apply your patch in a future release.

Moreover, length of the lscp output lines will exceed 80 characters
and the output gets unfit for general terminals after applying this
patch.  I think it needs to be modified in some way.

Thanks,
Ryusuke Konishi

> ---
>  bin/lscp.c |   29 ++++++++---------------------
>  man/lscp.1 |    7 -------
>  2 files changed, 8 insertions(+), 28 deletions(-)
> 
> diff --git a/bin/lscp.c b/bin/lscp.c
> index df9a0af..bede2f7 100644
> --- a/bin/lscp.c
> +++ b/bin/lscp.c
> @@ -54,8 +54,6 @@
>  #ifdef _GNU_SOURCE
>  #include <getopt.h>
>  const static struct option long_option[] = {
> -	{"show-block-count", no_argument, NULL, 'b'},
> -	{"show-increment", no_argument, NULL, 'g'},
>  	{"reverse", no_argument, NULL, 'r'},
>  	{"snapshot", no_argument, NULL, 's'},
>  	{"index", required_argument, NULL, 'i'},
> @@ -65,8 +63,6 @@ const static struct option long_option[] = {
>  	{NULL, 0, NULL, 0}
>  };
>  #define LSCP_USAGE	"Usage: %s [OPTION]... [DEVICE]\n"		\
> -			"  -b, --show-block-count\t\tshow block count\n"\
> -			"  -g, --show-increment\t\tshow increment count\n"\
>  			"  -r, --reverse\t\treverse order\n"		\
>  			"  -s, --snapshot\tlist only snapshots\n"	\
>  			"  -i, --index\t\tcp/ss index\n"		\
> @@ -74,7 +70,7 @@ const static struct option long_option[] = {
>  			"  -h, --help\t\tdisplay this help and exit\n"	\
>  			"  -V, --version\t\tdisplay version and exit\n"
>  #else
> -#define LSCP_USAGE	"Usage: %s [-bgrshV] [-i cno] [-n lines] [device]\n"
> +#define LSCP_USAGE	"Usage: %s [-rshV] [-i cno] [-n lines] [device]\n"
>  #endif	/* _GNU_SOURCE */
>  
>  #define LSCP_BUFSIZE	128
> @@ -85,13 +81,11 @@ const static struct option long_option[] = {
>  static __u64 param_index;
>  static __u64 param_lines;
>  static struct nilfs_cpinfo cpinfos[LSCP_NCPINFO];
> -static int show_block_count = 0;
>  
>  static void lscp_print_header(void)
>  {
> -	printf("                 CNO        DATE     TIME  MODE  FLG     %s"
> -	       "       ICNT\n",
> -	       show_block_count ? " BLKCNT" : "NBLKINC");
> +	printf("                 CNO        DATE     TIME  MODE  FLG"
> +	       "     NBLKINC       BLKCNT       ICNT\n");
>  }
>  
>  static void lscp_print_cpinfo(struct nilfs_cpinfo *cpinfo)
> @@ -104,13 +98,12 @@ static void lscp_print_cpinfo(struct nilfs_cpinfo 
> *cpinfo)
>  	localtime_r(&t, &tm);
>  	strftime(timebuf, LSCP_BUFSIZE, "%F %T", &tm);
>  
> -	printf("%20llu  %s   %s    %s %12llu %10llu\n",
> +	printf("%20llu  %s   %s    %s %12llu %12llu %10llu\n",
>  	       (unsigned long long)cpinfo->ci_cno, timebuf,
>  	       nilfs_cpinfo_snapshot(cpinfo) ? "ss" : "cp",
>  	       nilfs_cpinfo_minor(cpinfo) ? "i" : "-",
> -	       (unsigned long long)(show_block_count ?
> -				    cpinfo->ci_blocks_count :
> -				    cpinfo->ci_nblk_inc),
> +	       (unsigned long long)cpinfo->ci_nblk_inc,
> +	       (unsigned long long)cpinfo->ci_blocks_count,
>  	       (unsigned long long)cpinfo->ci_inodes_count);
>  }
>  
> @@ -341,19 +334,13 @@ int main(int argc, char *argv[])
>  
>  
>  #ifdef _GNU_SOURCE
> -	while ((c = getopt_long(argc, argv, "bgrsi:n:hV",
> +	while ((c = getopt_long(argc, argv, "rsi:n:hV",
>  				long_option, &option_index)) >= 0) {
>  #else
> -	while ((c = getopt(argc, argv, "bgrsi:n:hV")) >= 0) {
> +	while ((c = getopt(argc, argv, "rsi:n:hV")) >= 0) {
>  #endif	/* _GNU_SOURCE */
>  
>  		switch (c) {
> -		case 'b':
> -			show_block_count = 1;
> -			break;
> -		case 'g':
> -			show_block_count = 0;
> -			break;
>  		case 'r':
>  			rvs = 1;
>  			break;
> diff --git a/man/lscp.1 b/man/lscp.1
> index b5a553b..e484499 100644
> --- a/man/lscp.1
> +++ b/man/lscp.1
> @@ -17,13 +17,6 @@ This command will fail if the \fIdevice\fP has no active 
> mounts of a
>  NILFS2 file system.
>  .SH OPTIONS
>  .TP
> -\fB\-b\fR, \fB\-\-show\-block\-count\fR
> -Show number of used blocks instead of appended blocks.
> -.TP
> -\fB\-g\fR, \fB\-\-show\-increment\fR
> -Show number of appended blocks instead of used blocks.  This is the
> -default mode.
> -.TP
>  \fB\-r\fR, \fB\-\-reverse\fR
>  Reverse order.
>  .TP
> -- 
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

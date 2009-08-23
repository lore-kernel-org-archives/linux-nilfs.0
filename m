From: Yuri Chislov <yuri-EJC0RcYdacHR7s880joybQ@public.gmane.org>
Subject: Re: Fail to mount NILFS.
Date: Sun, 23 Aug 2009 07:55:02 +0300
Message-ID: <200908230755.02831.yuri@itinteg.net>
References: <200908221736.42571.yuri@itinteg.net>
	<200908221936.12308.yuri@itinteg.net>
	<20090823.122322.09561031.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090823.122322.09561031.ryusuke-sG5X7nlA6pw@public.gmane.org>
Content-Disposition: inline
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
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

On Sunday 23 August 2009 06:23:22 Ryusuke Konishi wrote:
> If the new script find the blocks storing the root inode, it will also
> dump them to files like:
>
> ifile-2-seg649-1329203
> ifile-2-seg649-1329259
> ifile-2-seg649-1329315
> ifile-2-seg649-1329372
> ifile-2-seg649-1329428
> ifile-2-seg649-1329455
>
> Then, we can see if the root inode is actually broken or not.
Hi,

 There is output from script.
sudo ./find_root.sh /dev/cciss/c0d1p1 10938 | tee -a segment-with-root-
inode.log
find_root.sh: root inode not found

Thanks.
Yuri.

From: Anthony Doggett <Anthony2486-fDpYTK8McCxDP812hmKXO1pr/1R2p/CL@public.gmane.org>
Subject: Re: mkfs.nilfs2 -b 1024 -B 8192
Date: Tue, 9 Apr 2013 22:08:27 +0100
Message-ID: <20130409210827.GA3809@grill.lan>
References: <20130313071453.GA17072@grill.lan>
 <424816AD-A79B-4F3D-A886-8D0CC735812B@dubeyko.com>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <424816AD-A79B-4F3D-A886-8D0CC735812B-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Vyacheslav

I've been curious as to what within the "darcs whatsnew" was causing the
"nilfs_direct_assign: invalid pointer: 0" / "broken bmap" issue for 1kB
blocks and I had a quiet half hour today, so I've boiled it down to a
simpler script and a short bit of C.  I include both below just in case
you should find them useful.  I was surprised to see that the 'a' makes
it to the file despite the filesystem errors.

Kind regards,
Anthony

Script:
    VG=unencrypted
    gcc -Wall truncate_mmap.c
    #lvcreate --size 2G --name ntest $VG
    mkfs.nilfs2 -b 1024 -B 8192 /dev/mapper/$VG-ntest
    mkdir /var/tmp/n
    mkdir /var/tmp/n/ntest
    mount /dev/mapper/$VG-ntest /var/tmp/n/ntest
    cd /var/tmp/n/ntest
    sleep 2
    date
    dmesg|tail -n 5
    $OLDPWD/a.out
    date
    sleep 8
    dmesg|tail -n 5

truncate_mmap.c:
    #include <fcntl.h>
    #include <stdio.h>
    #include <stdlib.h>
    #include <sys/mman.h>
    #include <unistd.h>

    #define handle_error(msg) \
       do { perror(msg); exit(EXIT_FAILURE); } while (0)

    int main()
    {
        char *addr;
        int fd;
        int t;
        int c;
        size_t size = 60;

        fd = open("truncate_mmap.tst", O_RDWR|O_CREAT|O_NOCTTY);
        if (fd == -1)
            handle_error("open");
        t = ftruncate(fd, (off_t) size);
        if (t != 0)
            handle_error("ftruncate");
        addr = mmap(NULL, size, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
        if (addr == MAP_FAILED)
            handle_error("mmap");
        addr[0] = 'a';
        c = close(fd);
        if (c != 0)
            handle_error("close");
        exit(EXIT_SUCCESS);
    }
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

# -*- coding: utf-8 -*-
import os
import sys
import re
import stat


def gen_thp_seq(dsqgen_file, scale, query_dir):
    flags = os.O_WRONLY | os.O_CREAT | os.O_EXCL
    modes = stat.S_IWUSR | stat.S_IRUSR
    if not os.path.exists(query_dir):
        os.mkdir(query_dir)

    cmd = dsqgen_file + ' -input ../query_templates/templates.lst -directory ../query_templates/ -scale ' + str(scale) + ' -dialect hwdws'
    os.system(cmd)
    with open('query_0.sql', 'r') as f1:
        line = f1.readline()
        queryname = ''
        while line:
            if '-- begin' in line.strip():
                #line:'-- begin query 1 in stream 0 using template query96.tpl\n'
                queryname = line.split(' ')[-1][5:-5]
                fquery = os.fdopen(os.open(query_dir + '/Q' + queryname, flags, modes), 'w+')
                line = f1.readline()
                continue

            if not queryname or line == '\n':
                line = f1.readline()
                continue

            if '-- end' in line.strip():
                fquery.close()
                line = f1.readline()
                continue

            if 'days)' in line:
                line = line.replace('days', '')
            fquery.write(line)
            line = f1.readline()

    print("TPCDS Q1~Q99 query store at " + query_dir)
    os.system('rm -rf query_0.sql')



if __name__ == '__main__':
    if len(sys.argv) != 4:
        print('Wrong number of parameters！')
        print('Usage：python3 gen_tpcds_thpseq.py dsqgen_file_path scale query_dir')
        print("""Parameter:
            qgen_file_path: tpcds dsqgen文件路径
            scale: 生成查询对应的数据规模
            query_dir: 生成文件的存放路径""")
        print("""Example:
            python3 gen_tpcds_thpseq.py ./dsqgen 1000 tpcds_query1000x""")
        sys.exit(1)

    dsqgen_file_path = sys.argv[1]
    scale = sys.argv[2]
    query_dir = sys.argv[3]
    try:
        if not re.match(r'^\.?\/(\w+\/?)+$', dsqgen_file_path):
            print("error param qgenfilepath:", dsqgen_file_path)
        if not re.match(r'\d+', scale):
            print('error param scale:', scale)
        if not re.match(r'^\/?(\w+\/?)+$', query_dir):
            print('error param query_dir:', query_dir)
    except Exception as ex:
        print('exception: invalid param!')

    if not os.path.isfile(dsqgen_file_path):
        print('The file %s is not exist!' % dsqgen_file_path)
        sys.exit(1)

    gen_thp_seq(dsqgen_file_path, int(scale), query_dir)
